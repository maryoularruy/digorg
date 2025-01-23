//
//  Extension+String.swift
//  Cleaner
//
//  Created by Александр Пономарёв on 27.05.2022.
//

import Foundation

extension String {
	func toNSDate(format: String) -> NSDate {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = format
		return dateFormatter.date(from: self) as NSDate? ?? NSDate()
	}
	
    func removeImageAndToInt() -> Int {
        Int(self.replacingOccurrences(of: "image", with: "")) ?? 0
    }
    
    func removeVideoAndToInt() -> Int {
        Int(self.replacingOccurrences(of: "video", with: "")) ?? 0
    }
    
    func trimingLeadingSpaces(using characterSet: CharacterSet = .whitespacesAndNewlines) -> String {
        guard let index = firstIndex(where: { !CharacterSet(charactersIn: String($0)).isSubset(of: characterSet) }) else { return self }
        return String(self[index...])
    }
}
