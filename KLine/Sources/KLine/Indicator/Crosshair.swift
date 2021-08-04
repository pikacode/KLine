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

    public var showHorizontal = true

    var point: CGPoint?

    /// set to nil if u want to hide
    public var horizontal: LimitLine? {
        if let y = point?.y {
            let l = LimitLine(y.double, .horizontal)
            object_setClass(l.limitLine, KLCrosshairLimitLine.self)
            l.limitLine.drawLabelEnabled = false
            return l
        } else {
            return nil
        }
    }

    public var vertical: LimitLine? {
        if let x = point?.x {
            let l = LimitLine(x.double, .vertical)
            object_setClass(l.limitLine, KLCrosshairLimitLine.self)
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
