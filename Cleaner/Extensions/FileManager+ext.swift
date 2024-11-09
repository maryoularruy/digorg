import UIKit
import Contacts

extension FileManager {
    
    /// The user's document directory.
    var documentsDirectory: URL {
        let url = self.urls(for: .documentDirectory, in: .userDomainMask).first
        precondition(url != nil, "Could not find the user's directory.")
        return url!
    }

    /// The user's `Documents/Inbox` directory.
    var inboxDirectory: URL {
        documentsDirectory.appendingPathComponent("Inbox", isDirectory: true)
    }
    
    /// Removes all items in the user's temporary and `Documents/Inbox` directory.
    ///
    /// The system typically places files in the inbox directory when opening external files in the
    /// app.
    func clearTemporaryDirectories() throws {
        try clear(contentsOf: temporaryDirectory)
        try clear(contentsOf: inboxDirectory)
    }
    
    /// Deletes all items in the directory.
    func clear(contentsOf directory: URL) throws {
        do {
            try contentsOfDirectory(at: directory, includingPropertiesForKeys: [])
                .forEach(removeItem)
        }
    }

    /// Moves or copies the source file to a temporary directory (controlled by the application).
    ///
    /// If the file is copied, optionally deletes the source file (including when the copy operation
    /// fails). Throws an error if any operation fails, including deletion of the source file.
    func importFile(at source: URL, asCopy: Bool, deletingSource: Bool) throws -> URL {
        let temporaryURL = try createUniqueTemporaryDirectory()
            .appendingPathComponent(source.lastPathComponent)

        let deleteIfNeeded = {
            guard asCopy, deletingSource else { return }
            try self.removeItem(at: source)
        }
    
        do {
            if asCopy {
                try copyItem(at: source, to: temporaryURL)
            } else {
                try moveItem(at: source, to: temporaryURL)
            }
        } catch {
            try deleteIfNeeded()
            throw error
        }
        
        try deleteIfNeeded()
        return temporaryURL
    }
}

// MARK: - Creating Temporary Directories

extension FileManager {
    
    /// See `createUniqueDirectory(in:preferredName)`.
    func createUniqueTemporaryDirectory() throws -> URL {
        try createUniqueDirectory()
    }

    /// Creates a unique directory, in a temporary or other directory.
    ///
    /// - Parameters:
    ///   - directory: The containing directory in which to create the unique directory. If nil,
    ///     uses the user's temporary directory.
    ///   - preferredName: The base name for the directory. If the name is not unique, appends
    ///     indexes starting with 1. Uses a UUID by default.
    ///
    /// - Returns: The URL of the created directory.
    func createUniqueDirectory(
        in directory: URL? = nil,
        preferredName: String = UUID().uuidString
    ) throws -> URL {
        
        let directory = directory ?? temporaryDirectory

        var i = 0

        while true {
            do {
                let name = (i == 0) ? preferredName : "\(preferredName)-\(i)"
                let subdirectory = directory.appendingPathComponent(name, isDirectory: true)
                try createDirectory(at: subdirectory, withIntermediateDirectories: false)
                return subdirectory
            } catch CocoaError.fileWriteFileExists {
                i += 1
            }
        }
    }
}

extension FileManager {
    func saveImage(image: UIImage, imageName: String, folderName: String) throws {
        createFolderIfNeeded(folderName: folderName, isMedia: true)

        guard let data = image.jpegData(compressionQuality: 1.0),
            let url = getURLForImage(imageName: imageName, folderName: folderName) else { return }
        
        do {
            try data.write(to: url)
        } catch {
            print("Error saving image. ImageName: \(imageName). \(error)")
        }
    }
    
    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard let url = getURLForImage(imageName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path) else { return nil }
        return UIImage(contentsOfFile: url.path)
    }
    
    func getAll(folderName: String) throws -> [String] {
        guard let url = getURLForFolder(folderName: folderName) else { return [] }
        if #available(iOS 16.0, *) {
            return try FileManager.default.contentsOfDirectory(atPath: url.path())
        } else {
            return try FileManager.default.contentsOfDirectory(atPath: url.path)
        }
    }
    
    func saveSecretContacts(_ contacts: [CNContact]) {
        let folderName = UserDefaultsService.shared.get(String.self, key: .secretContactsFolder) ?? "contacts"
        createFolderIfNeeded(folderName: folderName, isMedia: false)
        
        guard let url = FileManager.default.getURLForFolder(folderName: folderName) else { return }
        
        if let fileName = UserDefaultsService.shared.get(String.self, key: .secretContactsFile) {
            
            if FileManager.default.fileExists(atPath: url.appendingPathComponent(fileName).path) {
                var currentSecretContacts = convertDataToContacts(url.appendingPathComponent(fileName)) ?? []
                currentSecretContacts.append(contentsOf: contacts)
                guard let data = convertContactsToData(currentSecretContacts) else { return }
                updateData(data, url: url.appendingPathComponent(fileName))
            } else {
                guard let data = convertContactsToData(contacts) else { return }
                FileManager.default.createFile(atPath: url.appendingPathComponent(fileName).path, contents: data)
            }
            
        } else {
            let randomName = UUID().uuidString
            UserDefaultsService.shared.set(randomName, key: .secretContactsFile)
            guard let fileName = UserDefaultsService.shared.get(String.self, key: .secretContactsFile),
                  let data = convertContactsToData(contacts) else { return }
            FileManager.default.createFile(atPath: url.appendingPathComponent(fileName).path, contents: data)
        }
    }
    
    func getSecretContacts() -> [CNContact]? {
        guard let folderName = UserDefaultsService.shared.get(String.self, key: .secretContactsFolder),
        let fileName = UserDefaultsService.shared.get(String.self, key: .secretContactsFile) else { return nil }
        
        guard let url = FileManager.default.getURLForFolder(folderName: folderName)?.appendingPathComponent(fileName) else { return nil }
        
        return convertDataToContacts(url)
    }
    
    private func convertContactsToData(_ contacts: [CNContact]) -> Data? {
        do {
            return try CNContactVCardSerialization.data(with: contacts)
        } catch { return nil }
    }
    
    private func convertDataToContacts(_ url: URL) -> [CNContact]? {
        do {
            let data = try Data(contentsOf: url)
            return try CNContactVCardSerialization.contacts(with: data)
        } catch { return nil }
    }
    
    private func updateData(_ data: Data, url: URL) {
        do {
            try data.write(to: url)
        } catch { print(error.localizedDescription) }
    }
    
    private func createFolderIfNeeded(folderName: String, isMedia: Bool) {
        guard let url = getURLForFolder(folderName: folderName) else { return }
        UserDefaultsService.shared.set(folderName, key: isMedia ? .secretAlbumFolder : .secretContactsFolder)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Error creating directory. FolderName: \(folderName). \(error)")
            }
        }
    }
    
    private func getURLForFolder(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return url.appendingPathComponent(folderName)
    }
    
    private func getURLForImage(imageName: String, folderName: String) -> URL? {
        guard let folderURL = getURLForFolder(folderName: folderName) else { return nil }
        return folderURL.appendingPathComponent(imageName)
    }
}
