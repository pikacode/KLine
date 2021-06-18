//
//  Crosshair.swift
//  KLine
//
//  Created by pikacode on 2021/6/2.
//

import UIKit
import Charts

class Crosshair {

    static let label = "KLCross"

    let horizontal: LimitLine
    let vertical: LimitLine

    init() {
        horizontal = LimitLine()
        vertical = LimitLine()
    }
    
}

extension Crosshair: KLIndicator {
    static var style: KLStyle = KLStyle.default

    static func lineDataSet(points data: [KLPoint]) -> [LineChartDataSet]? {
        return nil
    }
}
