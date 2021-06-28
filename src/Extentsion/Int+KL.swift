//
//  Int+KLine.swift
//  KLine
//
//  Created by pikacode on 2021/6/1.
//

import UIKit

public extension Int {
    var toColor: UIColor { return UIColor(hex: UInt(self)) }

    var double: Double { return Double(self) }
    var cgFloat: CGFloat { return CGFloat(self) }
}

extension CGFloat {
    var double: Double { return Double(self) }
    var int: Int { return Int(self) }
}

extension Double {
    var cgFloat: CGFloat { return CGFloat(self) }
    var int: Int { return Int(self) }
}
