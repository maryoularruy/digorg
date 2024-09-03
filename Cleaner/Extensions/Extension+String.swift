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
}

//extension String: Differentiable { }
