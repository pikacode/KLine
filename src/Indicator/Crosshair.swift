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

    var point = CGPoint.zero  

    /// set to nil if u want to hide
    public var horizontal: LimitLine {
        var l = LimitLine(point.y.double, .horizontal)
        l.limitLine.label = Crosshair.label
        l.limitLine.drawLabelEnabled = false
        return l
    }

    public var vertical: LimitLine {
        var l = LimitLine(point.x.double, .vertical)
        l.limitLine.label = Crosshair.label
        l.limitLine.drawLabelEnabled = false
        return l
    }

}

extension Crosshair: KLIndicator {
    public static var style: KLStyle = KLStyle.default
}
