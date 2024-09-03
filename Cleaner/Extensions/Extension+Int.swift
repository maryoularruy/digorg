//
//  Extension+Int.swift
//  XMASS
//
//  Created by Александр Пономарёв on 13.03.2023.
//

import Foundation

extension Int: Sequence {
    public func makeIterator() -> CountableRange<Int>.Iterator {
        return (0..<self).makeIterator()
    }
}
