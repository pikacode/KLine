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

    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
//        return "---"
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
//        if left {
//            if low {
//                return "↖ " + value.decimal.toString(precision: KLineView.precision)
//            } else {
//                return "↙ " + value.decimal.toString(precision: KLineView.precision)
//            }
//        } else {
//            if low {
//                return value.decimal.toString(precision: KLineView.precision) + " ↗"
//            } else {
//                return value.decimal.toString(precision: KLineView.precision) + " ↘"
//            }
//        }
    }
}
