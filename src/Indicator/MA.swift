//
//  MA.swift
//  KLine
//
//  Created by pikacode on 2021/6/15.
//

import UIKit
import Charts

open class MA {

    required public init() {}
    
    public var data: [Int: Double?] = MA.days.reduce(into: [Int: Double]()) { $0[$1] = nil }

    public static var days = [5, 10, 20]
    var days: [Int] { return Self.days }

    static func calculateMA(_ data: inout [KLineData], day: Int) {
        if day > data.count {
            return
        }
        for i in (day-1)..<(data.count-1) {
            if data[i].ma?.data[day] != nil {
                continue
            }
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

}

extension MA: KLIndicator {
    
    public static var style: KLStyle = KLStyle.default

    public static func calculate(_ data: inout [Any]) {
        guard var data = data as? [KLineData] else { return }
        days.forEach{
            self.calculateMA(&data, day: $0)
        }
    }

    public func lineDataSet(_ data: [Any]) -> [LineChartDataSet]? {
        guard let data = data as? [KLineData] else {
            return nil

        }
        let sets = days.compactMap { (day) -> LineChartDataSet in
            var entries = data.compactMap{ (d) -> ChartDataEntry? in
                if let value = d.ma?.data[day] as? Double {
                    return ChartDataEntry(x: d.x, y: value)
                } else {
                    return nil
                }
            }
            if entries.count == 0, let d = data.first {
                entries.append(ChartDataEntry(x: d.x, y: d.open))
            }
            let last = entries.last?.y ?? 0
            let label = String(format: "MA\(day):%.\(KLineView.precision)f", last)
            let set = LineChartDataSet(entries: entries, label: label)
            let index = days.firstIndex(of: day) ?? 0
            let color = [style.lineColor1, style.lineColor2, style.lineColor3][index]
            set.setColor(color)
            set.lineWidth = style.lineWidth1
            set.mode = .cubicBezier
            set.drawCirclesEnabled = false
            set.drawValuesEnabled = false
            set.axisDependency = .left
            return set
        }
        return sets
    }

}
