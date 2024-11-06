//
//  RealmManager.swift
//  Cleaner
//
//  Created by Alex on 27.12.2023.
//

import RealmSwift

final class RealmManager {
    static let shared = RealmManager()

    private var realm: Realm {
        let config = Realm.Configuration (
        schemaVersion: 2, migrationBlock: { _, oldSchemaVersion in
            if oldSchemaVersion < 2 {
            }
        })
        Realm.Configuration.defaultConfiguration = config
        do {
            return try Realm()
        } catch {
            fatalError("Realm can't be created")
        }
    }
    
    func add<T>(obj: T) throws where T: Object {
        try realm.write {
            realm.add(obj)
        }
    }
    
    func getAll<T>(type: T.Type) throws -> [T] where T: Object {
        let objs = Array(realm.objects(T.self))
        return objs
    }

    func saveCredential(link: String, username: String, password: String) {
        let newCredential = Credential(link: link, username: username, password: password)
        do {
            try realm.write {
                realm.add(newCredential)
            }
        } catch {
            print("Error saving credential: \(error)")
        }
    }

    func deleteCredential(_ credential: Credential) {
       try! realm.write {
           realm.delete(credential)
       }
   }
    
    func getCredentials() -> [Credential] {
        let credentials = realm.objects(Credential.self)
        return Array(credentials)
    }
    
    func deleteCredentials(_ credentials: [Credential]) {
        do {
            try realm.write {
                for credential in credentials {
                    realm.delete(credential)
                }
            }
        } catch {
            print("Error deleting credentials: \(error.localizedDescription)")
        }
    }
    
    func getCredentialsGroupedByFirstLetter() -> [String: [Credential]] {
        let credentials = realm.objects(Credential.self)

        let groupedCredentials = Dictionary(grouping: credentials) { credential in
            return String(credential.link.prefix(1)).uppercased()
        }

        return groupedCredentials
    }
    
    func updateCredential(_ credential: Credential, withLink link: String, username: String, password: String) {
        do {
            try realm.write {
                credential.link = link
                credential.username = username
                credential.password = password
                // Update other properties as needed
            }
        } catch {
            print("Error updating credential: \(error.localizedDescription)")
        }
    }
}
