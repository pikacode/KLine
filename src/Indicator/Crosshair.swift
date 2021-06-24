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

    /// set it nil if u want to hide
    public var horizontal: LimitLine? = LimitLine(0, .horizontal)
    public var vertical: LimitLine? = LimitLine(0, .vertical)

}

extension Crosshair: KLIndicator {
    public static var style: KLStyle = KLStyle.default

    static func lineDataSet(points data: [KLPoint]) -> [LineChartDataSet]? {
        return nil
    }
}
