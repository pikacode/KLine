//
//  MA.swift
//  KLine
//
//  Created by pikacode on 2021/6/15.
//

import UIKit
import Charts

open class MA: KLIndicator {

    public static var style: KLStyle = KLStyle.default

    public static var days = [7, 25, 60]

    var data: [Int: Double] = MA.days.reduce(into: [Int: Double]()) { $0[$1] = 0 }

    public static func calculate(_ data: inout [KLineData]) {
        days.forEach{
            self.calculateMA(&data, day: $0)
        }
    }

    static func calculateMA(_ data: inout [KLineData], day: Int) {
        if day > data.count {
            return
        }
        for i in (day-1)..<(data.count-1) {
            let sum: Double
            if let lastMA = data[(i-1)~]?.ma?.data[day], let closeN = data[(i-day)~]?.close {
                //上一个值存在，减去第一个，加上最后一个即可
                sum = lastMA * Double(day) - closeN + data[i].close
            } else {
                sum = data[(i-day+1)...i].reduce(into: 0) { $0 += $1.close }
            }
            let ma = data[i].ma ?? MA()
            ma.data[day] = sum/Double(day)
            data[i].ma = ma
        }
    }

    public static func lineData(_ data: [KLineData]) -> LineChartDataSet? {
        return nil
    }

}


