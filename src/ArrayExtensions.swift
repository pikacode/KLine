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
//                objc_sync_enter(self)
                if (self.startIndex..<self.endIndex).contains(index) {
                    let obj = self[index]
//                    objc_sync_exit(self)
                    return obj
                } else {
                    // outOfBoundsLog(file: file, function: function, line: line)
//                    objc_sync_exit(self)
                    return nil
                }
            } else {
                // outOfBoundsLog(file: file, function: function, line: line)
                return nil
            }
        }
        set {
            if let index = int.index, let newValue = newValue {
                if (self.startIndex ..< self.endIndex).contains(index) {
                    self[index] = newValue
                } else {
                    outOfBoundsLog(file: file, function: function, line: line)
                }
            } else {
                outOfBoundsLog(file: file, function: function, line: line)
            }
        }
    }

    subscript(bounds: OptionalRange, file: String = #file, function: String = #function, line: Int = #line) -> ArraySlice<Element>? {
        get {
            if let range = bounds.range {
                return self[range.clamped(to: self.startIndex ..< self.endIndex)]
            } else {
                outOfBoundsLog(file: file, function: function, line: line)
                return nil
            }
        }
        set {
            if let range = bounds.range, let newValue = newValue {
                self[range.clamped(to: self.startIndex ..< self.endIndex)] = newValue
            } else {
                outOfBoundsLog(file: file, function: function, line: line)
            }
        }
    }

    func outOfBoundsLog(file: String, function: String, line: Int) {

    }

}
