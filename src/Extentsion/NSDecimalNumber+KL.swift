//
//  NSDecimalNumber+KL.swift
//  KLine
//
//  Created by pikacode on 2021/8/6.
//

import UIKit

extension CGFloat {
    var decimal: NSDecimalNumber { return "\(self)".decimal }
}

extension Int {
    var decimal: NSDecimalNumber { return "\(self)".decimal }
}

extension Double {
    var decimal: NSDecimalNumber { return "\(self)".decimal }
}

extension String {

    var toDouble: Double {
        return decimal.doubleValue
    }

    var decimal: NSDecimalNumber {
        var str = self
        let num: NSDecimalNumber
        if str.contains(" K") {
            str = str.replacingOccurrences(of: " K", with: "")
            num = str.decimal * 1000
        } else if str.contains(" M") {
            str = str.replacingOccurrences(of: " M", with: "")
            num = str.decimal * 1000000
        } else if str.contains(" B") {
            str = str.replacingOccurrences(of: " B", with: "")
            num = str.decimal * 1000000000
        } else {
            num = NSDecimalNumber(string: str)
        }
        return num == NSDecimalNumber.notANumber ? .zero : num
    }

}

extension NSDecimalNumber {

    public static let formatter: NumberFormatter = {
        let precision = KLineView.precision
        let f = NumberFormatter()
        f.roundingMode = .down
        f.numberStyle = .decimal
        f.locale = Locale(identifier: "en_US")
        f.maximumFractionDigits = (precision >= 0) ? precision: 10
        f.minimumIntegerDigits = 1
        f.minimumFractionDigits = precision
        return f
    }()

    static let kl_formatter = NumberFormatter()

    func toString(precision: Int = 0, maxF: Int = 10, minI: Int = 1, roundingMode: NumberFormatter.RoundingMode = .down, numberStyle: NumberFormatter.Style = .none) -> String {
        var str = ""
        let number = self
        let formatter = NSDecimalNumber.kl_formatter
        formatter.roundingMode = roundingMode
        formatter.locale = Locale(identifier: "en_US")
        formatter.minimumFractionDigits = precision
        formatter.maximumFractionDigits = (precision >= 0) ? precision: maxF
        formatter.minimumIntegerDigits = minI
        formatter.numberStyle = numberStyle
        if let s = formatter.string(from: number) {
            str = s
        }
        return str
    }

}

extension NSDecimalNumber {
    
    static let zero = NSDecimalNumber(value: 0)

    static func + (l: NSDecimalNumber, r: NSDecimalNumber) -> NSDecimalNumber {
        return l.adding(r)
    }

    static func - (l: NSDecimalNumber, r: NSDecimalNumber) -> NSDecimalNumber {
        return l.subtracting(r)
    }

    static func * (l: NSDecimalNumber, r: NSDecimalNumber) -> NSDecimalNumber {
        return l.multiplying(by: r)
    }

    static func / (l: NSDecimalNumber, r: NSDecimalNumber) -> NSDecimalNumber {
        if r == .zero {
            return .zero
        } else {
            return l.dividing(by: r)
        }
    }
}
