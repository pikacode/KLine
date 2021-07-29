//
//  ArrayExtensions.swift
//  Exchange
//
//  Created by pikacode on 2020/8/3.
//  Copyright © 2020 Atom International. All rights reserved.
//

import UIKit

struct OptionalInt {
    var index: Int?
}

struct OptionalRange {
    var range: Range<Int>?
}

postfix operator ~
postfix func ~ (value: Int?) -> OptionalInt {
    return OptionalInt(index: value)
}
postfix func ~ (value: Range<Int>?) -> OptionalRange {
    return OptionalRange(range: value)
}
postfix func ~ (value: CountableClosedRange<Int>?) -> OptionalRange {
    if let value = value {
        return OptionalRange(range: Range<Int>(value))
    } else {
        return OptionalRange(range: nil)
    }
}

extension Array {
    subscript(int: OptionalInt, file: String = #file, function: String = #function, line: Int = #line) -> Element? {
        get {
            if let index = int.index {
                if (self.startIndex..<self.endIndex).contains(index) {
                    let obj = self[index]
                    return obj
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }
        set {
            if let index = int.index, let newValue = newValue {
                if (self.startIndex ..< self.endIndex).contains(index) {
                    self[index] = newValue
                }
            }
        }
    }

    subscript(bounds: OptionalRange, file: String = #file, function: String = #function, line: Int = #line) -> ArraySlice<Element>? {
        get {
            if let range = bounds.range {
                return self[range.clamped(to: self.startIndex ..< self.endIndex)]
            } else {
                return nil
            }
        }
        set {
            if let range = bounds.range, let newValue = newValue {
                self[range.clamped(to: self.startIndex ..< self.endIndex)] = newValue
            }
        }
    }

}

