import UIKit
import AVFoundation
import Contacts

extension FileManager {
    var documentsDirectory: URL {
        let url = self.urls(for: .documentDirectory, in: .userDomainMask).first
        precondition(url != nil, "Could not find the user's directory.")
        return url!
    }

    var inboxDirectory: URL {
        documentsDirectory.appendingPathComponent("Inbox", isDirectory: true)
    }
    
    func getAll(folderName: String) throws -> [String] {
        guard let url = getURLForFolder(folderName: folderName) else { return [] }
        if #available(iOS 16.0, *) {
            return try FileManager.default.contentsOfDirectory(atPath: url.path())
        } else {
            return try FileManager.default.contentsOfDirectory(atPath: url.path)
        }
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
    
    private func clear(contentsOf directory: URL) throws {
        do {
            try contentsOfDirectory(at: directory, includingPropertiesForKeys: []).forEach(removeItem)
        }
    }
}

// MARK: -Device Storage
extension FileManager {
    func getTotalStorageSizeInGigabytes() -> Int? {
        do {
            let attributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
            guard let sizeInBytes = attributes[.systemSize] as? NSNumber else { return nil }
            return Int(ceil(sizeInBytes.doubleValue / (1000 * 1000 * 1000)))
        } catch {
            return nil
        }
    }
    
    func getFreeStorageSizeInGigabytes() -> Int? {
        do {
            let attributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
            guard let sizeInBytes = attributes[.systemFreeSize] as? NSNumber else { return nil }
            return Int(ceil(sizeInBytes.doubleValue / (1000 * 1000 * 1000)))
        } catch {
            return nil
        }
    }
}

// MARK: -Photo&Video
extension FileManager {
    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard let url = getUrlForFile(fileName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path) else { return nil }
        return UIImage(contentsOfFile: url.path)
    }
    
    func getVideoURL(videoName: String, folderName: String) -> URL? {
        guard let url = getUrlForFile(fileName: videoName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path) else { return nil }
        return url
    }
    
    func getVideoThumbnail(from videoURL: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let asset = AVAsset(url: videoURL)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true

            let time = CMTime(seconds: 1, preferredTimescale: 600)
            do {
                let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)

                DispatchQueue.main.async {
                    completion(thumbnail)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    func saveImage(image: UIImage, imageName: String, folderName: String) throws {
        createFolderIfNeeded(folderName: folderName, isMedia: true)

        guard let data = image.jpegData(compressionQuality: 1.0),
            let url = getUrlForFile(fileName: "\(Date().timeIntervalSince1970) photo \(imageName)", folderName: folderName) else { return }
        
        try data.write(to: url)
    }
    
    func saveVideo(videoUrl: URL, folderName: String) throws {
        createFolderIfNeeded(folderName: folderName, isMedia: true)
        
        guard let url = getUrlForFile(fileName: "\(Date().timeIntervalSince1970) video \(videoUrl.lastPathComponent)", folderName: folderName) else { return }
        
        try FileManager.default.copyItem(at: videoUrl, to: url)
    }
    
    private func getUrlForFile(fileName: String, folderName: String) -> URL? {
        guard let folderURL = getURLForFolder(folderName: folderName) else { return nil }
        return folderURL.appendingPathComponent(fileName)
    }
}

// MARK: -Contacts
extension FileManager {
    func getSecretContacts() -> [CNContact]? {
        guard let folderName = UserDefaultsService.shared.get(String.self, key: .secretContactsFolder),
        let fileName = UserDefaultsService.shared.get(String.self, key: .secretContactsFile) else { return nil }
        
        guard let url = FileManager.default.getURLForFolder(folderName: folderName)?.appendingPathComponent(fileName) else { return nil }
        
        return convertDataToContacts(url)
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
}

// MARK: -Temporary Directories
extension FileManager {
    func createUniqueTemporaryDirectory() throws -> URL {
        try createUniqueDirectory()
    }

    func createUniqueDirectory(in directory: URL? = nil, preferredName: String = UUID().uuidString) throws -> URL {
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
    
    func clearTemporaryDirectories() throws {
        try clear(contentsOf: temporaryDirectory)
        try clear(contentsOf: inboxDirectory)
    }
    
    func importFile(at source: URL, asCopy: Bool, deletingSource: Bool) throws -> URL {
        let temporaryURL = try createUniqueTemporaryDirectory().appendingPathComponent(source.lastPathComponent)

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
