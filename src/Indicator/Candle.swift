//
//  Candle.swift
//  KLine
//
//  Created by pikacode on 2021/6/15.
//

import UIKit
import Charts

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
        set.valueFont = .systemFont(ofSize: 10)
        set.drawValuesEnabled = false
        set.shadowWidth = style.lineWidth1
        return [set]
    }

    public static var style: KLStyle = .default

    public static var xValueFormatter: IAxisValueFormatter? {
        return KLDateFormatter()
    }

}
