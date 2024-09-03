//
//  Extension+Set.swift
//  Cleaner
//
//  Created by Александр Пономарёв on 31.05.2022.
//

import Foundation

extension Set {
	@discardableResult mutating func insert(_ newMembers: [Set.Element]) -> [(inserted: Bool, memberAfterInsert: Set.Element)] {
		var returnArray: [(inserted: Bool, memberAfterInsert: Set.Element)] = []
		newMembers.forEach { (member) in
			returnArray.append(self.insert(member))
		}
		return returnArray
	}
}
