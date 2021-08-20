//
//  Candle.swift
//  KLine
//
//  Created by pikacode on 2021/6/15.
//

import UIKit
import Charts

class KLCandleValueFormatter: IValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
//        return "---"
        if viewPortHandler?.isInBoundsLeft(CGFloat(entry.x)) ?? false {
            return "   —— " + value.decimal.toString(precision: KLineView.precision)
        } else {
            return value.decimal.toString(precision: KLineView.precision) + " ——"
        }
    }

    func stringForValue(value: Double, left: Bool) -> String {
        if left {
            return "—— " + value.decimal.toString(precision: KLineView.precision)
        } else {
            return value.decimal.toString(precision: KLineView.precision) + " ——"
        }
    }
}

open class Candle: KLIndicator {
    
    required public init() {}
    
    public func candleDataSet(_ data: [Any]) -> [CandleChartDataSet]? {
        guard let data = data as? [KLineData] else { return nil }
        let entries = data.map{
            CandleChartDataEntry(x: $0.x, shadowH: $0.high, shadowL: $0.low, open: $0.open, close: $0.close)
        }
        let set = CandleChartDataSet(entries: entries, label: nil)
        set.increasingColor = style.upColor
        set.decreasingColor = style.downColor
        set.increasingFilled = true
        set.decreasingFilled = true
        set.shadowColorSameAsCandle = true
        if style.drawMaxMinValue {
            set.valueFont = .systemFont(ofSize: 10)
            set.drawValuesEnabled = true
            set.valueTextColor = UIColor.white.alpha(0.6)
            set.valueFormatter = KLCandleValueFormatter()
        }
        set.shadowWidth = style.lineWidth1
        return [set]
    }

    public static var style: KLStyle = {
        let d = KLStyle.default
        d.drawMaxMinValue = true
        return d
    }()

}
