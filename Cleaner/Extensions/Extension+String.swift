//
//  Extension+String.swift
//  Cleaner
//
//  Created by Александр Пономарёв on 27.05.2022.
//

import UIKit

extension String {
    var underlined: NSAttributedString {
        NSMutableAttributedString(string: self, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
    
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
    
    func trimLeadingSpaces(using characterSet: CharacterSet = .whitespacesAndNewlines) -> String {
        if CharacterSet(charactersIn: String(self)).isSubset(of: characterSet) {
            return ""
        }
            
        guard let index = firstIndex(where: { !CharacterSet(charactersIn: String($0)).isSubset(of: characterSet) }) else { return self }
        return String(self[index...])
    }
    
    func trimLeadingAndTrailingSpaces(using characterSet: CharacterSet = .whitespacesAndNewlines) -> String {
        trimmingCharacters(in: characterSet)
    }
}
