//
//  ContactManager.swift
//  Cleaner
//
//  Created by Максим Лебедев on 03.06.2022.
//

import ContactsUI

struct CNContactSection {
    let name: String
    var contacts: [CNContact]
}

final class ContactManager {
    static let shared = ContactManager()
    
    private let store = CNContactStore()
    private let defaultDescriptor = CNContactViewController.descriptorForRequiredKeys()
    
    func checkStatus(handler: @escaping (CNAuthorizationStatus) -> ()) {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        
        if status == .notDetermined {
            requestAutorization() { granted in
                handler(granted ? .authorized : .denied)
            }
        } else {
            handler(status)
        }
    }
    
    func countUnresolvedContacts(completion: @escaping (Int, Int, Int, Int, Int) -> ()) {
        fetchAllContacts { [weak self] contacts in
            guard let self else { return }
            let duplicatedByName = fitlerDuplicatedByName(contacts).count
            let duplicatedByNumber = fitlerDuplicatedByNumber(contacts).count
            let noName = filterIncompletedByName(contacts).count
            let noNumber = filterIncompletedByNumber(contacts).count
            let unresolvedContacts = duplicatedByName + duplicatedByNumber + noName + noNumber
            
            completion(duplicatedByName, duplicatedByNumber, noName, noNumber, unresolvedContacts)
        }
    }

    func loadDuplicatedByName(completion: @escaping ([[CNContact]]) -> ()) {
        fetchAllContacts { [weak self] contacts in
            guard let self else { return }
            completion(fitlerDuplicatedByName(contacts))
        }
    }
    
    func loadDuplicatedByNumber(completion: @escaping ([[CNContact]]) -> ()) {
        fetchAllContacts { [weak self] contacts in
            guard let self else { return }
            completion(fitlerDuplicatedByNumber(contacts))
        }
    }
    
    func loadIncompletedByName(completion: @escaping ([CNContact]) -> ()) {
        fetchAllContacts { contacts in
            completion(contacts.filter { $0.givenName.isEmpty && $0.familyName.isEmpty && !$0.phoneNumbers.isEmpty })
        }
    }
    
    func loadIncompletedByNumber(completion: @escaping ([CNContact]) -> ()) {
        fetchAllContacts { contacts in
            completion(contacts.filter { $0.phoneNumbers.isEmpty })
        }
    }
    
    func merge(_ contacts: [CNContact], completion: @escaping ((Bool) -> ())) {
        var bestContact: CNContact?
        var bestValue: Int = 0
        for contact in contacts {
            if contact.calcRating() > bestValue {
                bestValue = contact.calcRating()
                bestContact = contact
            }
        }
        
        let contactsForDeletion = contacts.filter { $0 != bestContact! }
        guard let contactForMerging = bestContact?.mutableCopy() as? CNMutableContact else { return }
        
        contactsForDeletion.forEach { deletedContact in
            deletedContact.phoneNumbers.forEach { phoneNumber in
                var isExistingNumber: Bool = false
                for number in contactForMerging.phoneNumbers {
                    if number.value == phoneNumber.value {
                        isExistingNumber = true
                        break
                    }
                }
                
                if !isExistingNumber {
                    contactForMerging.phoneNumbers.append(CNLabeledValue(label: phoneNumber.label, value: phoneNumber.value))
                }
            }
        }
    
        do {
            try updateContact(contactForMerging)
            delete(contactsForDeletion)
            completion(true)
        } catch {
            completion(false)
        }
    }
    
    func merge(_ contacts: [CNContact], userChoice: Int, completion: @escaping ((Bool) -> ())) {
        let contactsForDeletion = contacts.filter { $0 != contacts[userChoice] }
        guard let contactForMerging = contacts[userChoice].mutableCopy() as? CNMutableContact else { return }
        
        contactsForDeletion.forEach { deletedContact in
            deletedContact.phoneNumbers.forEach { phoneNumber in
                var isExistingNumber: Bool = false
                for number in contactForMerging.phoneNumbers {
                    if number.value == phoneNumber.value {
                        isExistingNumber = true
                        break
                    }
                }
                
                if !isExistingNumber {
                    contactForMerging.phoneNumbers.append(CNLabeledValue(label: phoneNumber.label, value: phoneNumber.value))
                }
            }
        }

        do {
            try updateContact(contactForMerging)
            delete(contactsForDeletion)
            completion(true)
        } catch {
            completion(false)
        }
    }
    
    func findContact(contact: CNContact) -> CNContact? {
        do {
            return try store.unifiedContact(withIdentifier: contact.identifier, keysToFetch: [defaultDescriptor])
        } catch {
            print("Failed to get contact from CNContactStore: \(error.localizedDescription)")
            return nil
        }
    }
    
    func delete(_ contacts: [CNContact]) {
        contacts.forEach { delete($0) }
    }
    
    func delete(_ contact: CNContact) {
        let request = CNSaveRequest()
        request.delete(contact.mutableCopy() as! CNMutableContact)
        do {
            try store.execute(request)
        } catch {}
    }
    
    func loadAllContacts(completion: @escaping ([CNContactSection]) -> ()) {
        fetchAllContacts { [weak self] contacts in
            guard let self else { return }
            completion(sortBySections(contacts))
        }
    }
    
    func importSecretContacts(_ contacts: [CNContact]) {
        FileManager.default.saveSecretContacts(contacts)
        delete(contacts)
    }
    
    func findDuplicatedNumber(_ contacts: [CNContact]) -> String? {
        for i in 0..<contacts.count {
            for j in 0..<contacts[i].phoneNumbers.count {
                for k in 0..<contacts[i+1].phoneNumbers.count {
                    if contacts[i].phoneNumbers[j].value.stringValue == contacts[i+1].phoneNumbers[k].value.stringValue {
                        return contacts[i].phoneNumbers[j].value.stringValue
                    }
                }
            }
        }
        return nil
    }
    
    static func getSecretContacts() -> [CNContact]? {
        FileManager.default.getSecretContacts()
    }
    
    private func requestAutorization(handler: @escaping (Bool) -> ()) {
        store.requestAccess(for: .contacts) { granted, _ in
            handler(granted)
        }
    }
    
    private func fetchAllContacts(handler: @escaping (([CNContact]) -> ())) {
        checkStatus { [weak self] in
            guard let self else { return }
            do {
                var contacts: [CNContact] = []
                let fetchRequest = CNContactFetchRequest(keysToFetch: [CNContactVCardSerialization.descriptorForRequiredKeys()])
                fetchRequest.unifyResults = true
                fetchRequest.sortOrder = .none
                
                try store.enumerateContacts(with: fetchRequest) { contact, _ in
                    contacts.append(contact)
                }
                handler(contacts)
            } catch {}
        }
    }
    
    private func checkStatus(handler: @escaping () -> ()) {
        if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
            handler()
        } else {
            requestContactAccess {
                handler()
            }
        }
    }
    
    private func requestContactAccess(handler: @escaping () -> ()) {
        store.requestAccess(for: .contacts) { _, error in
            if error != nil {
                print("Contacts Access Denied: \(error.localizedDescription)")
                handler()
            }
            handler()
        }
    }
    
    private func updateContact(_ contact: CNMutableContact) throws {
        let saveRequest = CNSaveRequest()
        saveRequest.update(contact)
        try store.execute(saveRequest)
    }
    
    private func sortBySections(_ contacts: [CNContact]) -> [CNContactSection] {
        var letters: [String] = []
        var sections: [CNContactSection] = []
        
        contacts.forEach { contact in
            if contact.givenName.isEmpty {
                if !letters.contains("#") {
                    letters.append("#")
                }
            } else {
                if contact.givenName.first!.isLetter {
                    if !letters.contains(String(contact.givenName.first!)) {
                        letters.append(String(contact.givenName.first!))
                    }
                } else {
                    if !letters.contains("#") {
                        letters.append("#")
                    }
                }
            }
        }
        
        letters = letters.map { $0.uppercased() }
        letters = Array(Set(letters))
        letters.sort { $0 < $1 }
        
        for letter in letters {
            if letter == "#" {
                sections.append(CNContactSection(name: letter, contacts: contacts
                    .filter { $0.givenName.isEmpty || !$0.givenName[$0.givenName.startIndex].isLetter }
                    .sorted { $0.givenName < $1.givenName }))
                continue
            }
            
            let contacts = contacts
                .filter { $0.givenName.uppercased().starts(with: letter) }
                .sorted { $0.givenName < $1.givenName }
            
            if !contacts.isEmpty {
                sections.append(CNContactSection(name: letter, contacts: contacts))
            }
        }
        return sections
    }
    
    private func fitlerDuplicatedByName(_ contacts: [CNContact]) -> [[CNContact]] {
        var duplicates = [[CNContact]]()
        var checkedContacts = Set<CNContact>()
        
        for i in 0..<contacts.count {
            if checkedContacts.contains(contacts[i]) || contacts[i].givenName.isEmpty && contacts[i].familyName.isEmpty {
                continue
            }
            
            var group = [CNContact]()
            group.append(contacts[i])
            
            for j in i+1..<contacts.count {
                if checkedContacts.contains(contacts[j]) {
                    continue
                }
                
                if (contacts[i].givenName + " " + contacts[i].familyName == contacts[j].givenName + " " + contacts[j].familyName) {
                    group.append(contacts[j])
                    checkedContacts.insert(contacts[j])
                }
            }
            
            if group.count > 1 {
                duplicates.append(group)
            }
            
            checkedContacts.insert(contacts[i])
        }
        return duplicates
    }
    
    private func fitlerDuplicatedByNumber(_ contacts: [CNContact]) -> [[CNContact]] {
        var duplicates = [[CNContact]]()
        var checkedContacts = Set<CNContact>()
        
        for i in 0..<contacts.count {
            if checkedContacts.contains(contacts[i]) || contacts[i].phoneNumbers.isEmpty {
                continue
            }
            
            var group = [CNContact]()
            group.append(contacts[i])
            
            for j in i+1..<contacts.count {
                if checkedContacts.contains(contacts[i]) {
                    continue
                }

                contacts[i].phoneNumbers.forEach { firstNumber in
                    contacts[j].phoneNumbers.forEach { secondNumber in
                        if firstNumber.value.stringValue == secondNumber.value.stringValue {
                            group.append(contacts[j])
                            checkedContacts.insert(contacts[j])
                        }
                    }
                }
            }
            
            if group.count > 1 {
                duplicates.append(group)
            }
            
            checkedContacts.insert(contacts[i])
        }
        return duplicates
    }
    
    private func filterIncompletedByName(_ contacts: [CNContact]) -> [CNContact] {
        contacts.filter { $0.givenName.isEmpty && $0.familyName.isEmpty && !$0.phoneNumbers.isEmpty }
    }
    
    private func filterIncompletedByNumber(_ contacts: [CNContact]) -> [CNContact] {
        contacts.filter { $0.phoneNumbers.isEmpty }
    }
}
