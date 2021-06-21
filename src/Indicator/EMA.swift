//
//  EMA.swift
//  KLine
//
//  Created by aax1 on 2021/6/17.
//

import UIKit
import Charts

open class EMA {

    required public init() {}
    
    public static var days = [7, 25, 99]
    var days: [Int] { return Self.days }

    public var data: [Int: Double] = EMA.days.reduce(into: [Int: Double]()) { $0[$1] = 0 }
    
    static func calculateEMA(_ data: inout [KLineData], day: Int) {
        for i in 0..<(data.count - 1) {
            let model = data[i]
            let ema = data[i].ema ?? EMA()
            if i == 0 {
                //第一天的ema12 是收盘价
                ema.data[day] =  model.close
            } else {
                if  let lastEmaDay = model.ema?.data[day - 1] {
                    ema.data[day] = Double((2 / (day + 1))) * (model.close - lastEmaDay) + lastEmaDay
                }
            }
            data[i].ema = ema
        }
    }

}

extension EMA: KLIndicator {

    public static var style: KLStyle = KLStyle.default

    public static func calculate(_ data: inout [Any]) {
        guard var data = data as? [KLineData] else { return }
        days.forEach{
            self.calculateEMA(&data, day: $0)
        }
    }

    public func lineDataSet(_ data: [Any]) -> [LineChartDataSet]? {
        guard let data = data as? [KLineData] else { return nil }

        let sets = days.map { (day) -> LineChartDataSet in
            let entries = data.compactMap{ (d) -> ChartDataEntry? in
                if let value = d.ema?.data[day] {
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
