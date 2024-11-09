//
//  ContactService.swift
//  Cleaner
//
//  Created by Максим Лебедев on 03.06.2022.
//

import SwiftyContacts
import ContactsUI
import OSLog

struct CNContactSection {
    let name: String
    var contacts: [CNContact]
}

final class ContactManager {
    private static var logger = Logger()
    private static var store = CNContactStore()
    private static var defaultDescriptor = CNContactViewController.descriptorForRequiredKeys()

    static func loadDuplicatedByName(completion: @escaping ([[CNContact]]) -> ()) {
        loadContacts { contacts in
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
                    
                    if (contacts[i].givenName + " " + contacts[i].familyName == contacts[j].givenName + " " + contacts[j].familyName) ||
                        (!contacts[i].phoneNumbers.isEmpty && (contacts[i].phoneNumbers.first?.value.stringValue == contacts[j].phoneNumbers.first?.value.stringValue)) ||
                        (!contacts[i].emailAddresses.isEmpty && (contacts[i].emailAddresses.first?.value == contacts[j].emailAddresses.first?.value)) {
                        group.append(contacts[j])
                        checkedContacts.insert(contacts[j])
                    }
                }
                
                if group.count > 1 {
                    duplicates.append(group)
                }
                
                checkedContacts.insert(contacts[i])
            }
            completion(duplicates)
        }
    }
    
    static func loadIncompletedByName(completion: @escaping ([CNContact]) -> ()) {
        loadContacts { contacts in
            completion(contacts.filter { $0.givenName.isEmpty && $0.familyName.isEmpty && !$0.phoneNumbers.isEmpty })
        }
    }
    
    static func loadIncompletedByNumber(completion: @escaping ([CNContact]) -> ()) {
        loadContacts { contacts in
            completion(contacts.filter { $0.phoneNumbers.isEmpty })
        }
    }
    
    static func merge(_ contacts: [CNContact], completion: @escaping ((Bool) -> ())) {
        var bestContact: CNContact?
        var bestValue: Int = 0
        for contact in contacts {
            if contact.calcRating() > bestValue {
                bestValue = contact.calcRating()
                bestContact = contact
            }
        }
        
        let deleteContacts = contacts.filter { $0 != bestContact! }
        guard let bestContact = bestContact?.mutableCopy() as? CNMutableContact else { return }
        deleteContacts.forEach { bestContact.phoneNumbers.append(contentsOf: $0.phoneNumbers) }

        do {
            try updateContact(bestContact)
        } catch {
            print(error.localizedDescription)
        }
        delete(deleteContacts)
        DispatchQueue.main.async {
            completion(true)
        }
    }
    
    static func findContact(contact: CNContact) -> CNContact? {
        do {
            return try store.unifiedContact(withIdentifier: contact.identifier, keysToFetch: [defaultDescriptor])
        } catch {
            logger.error("Failed to get contact from CNContactStore: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func delete(_ contacts: [CNContact]) {
        contacts.forEach { delete($0) }
    }
    
    static func delete(_ contact: CNContact) {
        let request = CNSaveRequest()
        request.delete(contact.mutableCopy() as! CNMutableContact)
        do {
            try store.execute(request)
        } catch {}
    }
    
    static func loadAllContacts(completion: @escaping ([CNContactSection]) -> ()) {
        loadContacts { contacts in
            completion(sortBySections(contacts))
        }
    }
    
    static func importSecretContacts(_ contacts: [CNContact]) {
        FileManager.default.saveSecretContacts(contacts)
    }
    
    static func getSecretContacts() -> [CNContact]? {
        FileManager.default.getSecretContacts()
    }
    
    private static func loadContacts(handler: @escaping (([CNContact]) -> ())) {
        checkStatus {
            fetchContacts { result in
                switch result {
                case .success(let contacts): handler(contacts)
                case .failure: break
                }
            }
        }
    }
    
    private static func checkStatus(handler: @escaping () -> ()) {
        if authorizationStatus() == .authorized {
            handler()
        } else {
            requestContactAccess {
                handler()
            }
        }
    }
    
    private static func requestContactAccess(handler: @escaping () -> ()) {
        requestAccess { response in
            switch response {
            case .success(_):
                handler()
                logger.info("Contacts Access Granted")
            case .failure(let error):
                logger.warning("Contacts Access Denied: \(error.localizedDescription)")
            }
        }
    }
    
    private static func sortBySections(_ contacts: [CNContact]) -> [CNContactSection] {
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
}
