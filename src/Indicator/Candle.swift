//
//  Candle.swift
//  KLine
//
//  Created by pikacode on 2021/6/15.
//

import UIKit
import Charts

open class Candle: KLIndicator {

    public static func candleData(_ data: [KLineData]) -> CandleChartDataSet? {
        let entries = data.map{
            CandleChartDataEntry(x: $0.time/50000, shadowH: $0.high, shadowL: $0.low, open: $0.open, close: $0.close)
        }
        let set = CandleChartDataSet(entries: entries, label: "Candle DataSet")
        set.setColor(UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1))
        set.decreasingColor = UIColor(red: 142/255, green: 150/255, blue: 175/255, alpha: 1)
        set.shadowColor = .darkGray
        set.valueFont = .systemFont(ofSize: 10)
        set.drawValuesEnabled = false
        set.shadowWidth = 1

        entries.forEach{
            print("o \($0.open) c \($0.close) h \($0.high) l \($0.low)")
        }
        return set
    }
    
    public static func calculate(_ data: inout [KLineData]) {

    }

    public static var style: KLStyle = .default

}
