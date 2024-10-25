//
//  ContactService.swift
//  Cleaner
//
//  Created by Максим Лебедев on 03.06.2022.
//

import Foundation
import SwiftyContacts
import SwiftyUserDefaults
import Contacts
import ContactsUI
import OSLog

class CNContactSection {
    let name: String
    var contacts: [CNContact]

    init(name: String, contacts: [CNContact]) {
        self.name = name
        self.contacts = contacts
    }
}

final class ContactManager {
    private static var logger = Logger()
    private static var store = CNContactStore()
    private static var defaultDescriptor = CNContactViewController.descriptorForRequiredKeys()
    
//    public static func loadSecretContacts(_ handler: @escaping ((_ contacts: [CNContact]) -> Void)){
//        checkStatus {
//            fetchContacts(completionHandler: { (result) in
//                switch result {
//                case .success(let contacts):
//                    handler(contacts.filter({ Defaults[\.secretContacts].contains($0.identifier) }))
//                    // Do your thing here with [CNContacts] array
//                    break
//                case .failure:
//                    break
//                }
//            })
//        }
//    }

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
    
    public static func sortContactSections(_ contacts: [CNContact]) -> [CNContactSection] {
        var letters: [String] = []
        var sections: [CNContactSection] = []
        for contact in contacts{
            if !contact.givenName.isEmpty{
                if !contact.givenName[String.Index(encodedOffset: 0)].isLetter{
                    if !letters.contains("#"){
                        letters.append("#")
                    }
                }
                else{
                    if !letters.contains(String(contact.givenName[String.Index(encodedOffset: 0)])){
                        letters.append(String(contact.givenName[String.Index(encodedOffset: 0)]))
                    }
                }
            }
            else if contact.givenName.isEmpty {
                    if !letters.contains("#"){
                        letters.append("#")
                    }
            }
        }
        letters = letters.map({ $0.uppercased()})
        letters = Array(Set(letters))
        letters.sort(by: {
            (letter1, letter2) in
            letter1 < letter2
        })
        for letter in letters{
            if letter == "#"{
                sections.append(CNContactSection(name: letter, contacts: contacts.filter({
                    $0.givenName.isEmpty || !$0.givenName[String.Index(encodedOffset: 0)].isLetter }).sorted(by: {
                    (contact1, contact2) in
                    contact1.givenName < contact2.givenName
                })))
                continue
            }
            let contacts = contacts.filter({ $0.givenName.uppercased().starts(with: letter) }).sorted(by: {
                (contact1, contact2) in
                contact1.givenName < contact2.givenName
            })
            if contacts.count != 0{
                sections.append(CNContactSection(name: letter, contacts: contacts))
            }
        }
        return sections
    }
}
