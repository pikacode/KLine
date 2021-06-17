//
//  Candle.swift
//  KLine
//
//  Created by pikacode on 2021/6/15.
//

import UIKit
import Charts

open class Candle: KLIndicator {

    public static func candleData(_ data: [KLineData]) -> [CandleChartDataSet]? {
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
        set.shadowWidth = 1
        return [set]
    }
    
    public static func calculate(_ data: inout [KLineData]) {

    }

    public static var style: KLStyle = .default

}
