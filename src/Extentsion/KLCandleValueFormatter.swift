//
//  KLCandleValueFormatter.swift
//  KLine
//
//  Created by pikacode on 2021/8/30.
//

import UIKit
import Charts

open class KLCandleValueFormatter: IValueFormatter {

    public init() {}

    public func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        if viewPortHandler?.isInBoundsLeft(CGFloat(entry.x)) ?? false {
            return "   —— " + value.decimal.toString(precision: KLineView.precision)
        } else {
            return value.decimal.toString(precision: KLineView.precision) + " ——"
        }
    }

    func stringForValue(value: Double, left: Bool, low: Bool) -> String {
        if left {
            return "—— " + value.decimal.toString(precision: KLineView.precision)
        } else {
            return value.decimal.toString(precision: KLineView.precision) + " ——"
        }
    }
}
