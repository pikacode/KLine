//
//  Crosshair.swift
//  KLine
//
//  Created by pikacode on 2021/6/2.
//

import UIKit
import Charts

class Crosshair {

    required public init() {}

    static let label = "KLCross"

    let horizontal = LimitLine(0, .horizontal)
    let vertical = LimitLine(0, .vertical)

}

extension Crosshair: KLIndicator {
    static var style: KLStyle = KLStyle.default

    static func lineDataSet(points data: [KLPoint]) -> [LineChartDataSet]? {
        return nil
    }
}
