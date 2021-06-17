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

    var data: [Int: Double?] = MA.days.reduce(into: [Int: Double]()) { $0[$1] = nil }

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
            if let lastMA = data[(i-1)~]?.ma?.data[day] as? Double, let closeN = data[(i-day)~]?.close {
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

    public static func lineData(_ data: [KLineData]) -> [LineChartDataSet]? {
        let sets = days.map { (day) -> LineChartDataSet in
            let entries = data.compactMap{ (d) -> ChartDataEntry? in
                if let value = d.ma?.data[day] as? Double {
                    return ChartDataEntry(x: d.x, y: value)
                } else {
                    return nil
                }
            }
            let set = LineChartDataSet(entries: entries, label: "")
            let index = days.firstIndex(of: day) ?? 0
            let color = [style.lineColor1, style.lineColor2, style.lineColor3][index]
            set.setColor(color)
            set.setCircleColor(UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1))
            set.lineWidth = 0.5
            set.circleRadius = 0
            set.circleHoleRadius = 0
            set.fillColor = UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1)
            set.mode = .cubicBezier
            set.drawValuesEnabled = true
            set.valueFont = .systemFont(ofSize: 0)
            set.valueTextColor = UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1)
            set.axisDependency = .left
            return set
        }
        return sets
    }

}


