//
//  Crosshair.swift
//  KLine
//
//  Created by pikacode on 2021/6/2.
//

import UIKit
import Charts

open class Crosshair {
    required public init() {}

    static let label = "KLCross"

    var showHorizontal = true

    var point: CGPoint?

    /// set to nil if u want to hide
    public var horizontal: LimitLine? {
        if let y = point?.y {
            var l = LimitLine(y.double, .horizontal)
            l.limitLine.label = Crosshair.label
            l.limitLine.drawLabelEnabled = false
            return l
        } else {
            return nil
        }
    }

    public var vertical: LimitLine? {
        if let x = point?.x {
            var l = LimitLine(x.double, .vertical)
            l.limitLine.label = Crosshair.label
            l.limitLine.drawLabelEnabled = false
            return l
        } else {
            return nil
        }
    }

}

extension Crosshair: KLIndicator {
    public static var style: KLStyle = KLStyle.default
}
