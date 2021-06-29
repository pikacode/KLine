//
//  MAVOL.swift
//  KLine
//
//  Created by pikacode on 2021/6/22.
//

import UIKit
import Charts




open class MAVOL {
    public static var days = [5, 10]
    var days: [Int] { return Self.days }
    public var data: [Int: Double?] = MAVOL.days.reduce(into: [Int: Double]()) { $0[$1] = nil }
    

    required public init() { }
    static func calculateMAVOL(_ data: inout [KLineData], day: Int) {
        if data.count < day { return }
        for i in day - 1 ..< data.count - 1 {
            var sum: Double = 0
            if let lastSum = data[(i - 1)].mavol?.data[day] as? Double, let close = data[(i-day)~]?.close  {
    sum = lastSum * Double(day) - close + data[i].close
            }else{
                sum = data[(i-day+1)...i].reduce(into: 0) { $0 += $1.close }
            }
            let mavol = data[i].mavol ?? MAVOL()
            mavol.data[day] = sum/Double(day)
            data[i].mavol = mavol
        }
        
    }
}

extension MAVOL: KLIndicator {
    public static var style: KLStyle = KLStyle.default
   
    public static func calculate(_ data: inout [Any]) {
        guard var data = data as? [KLineData] else { return }
        days.forEach{
            self.calculateMAVOL(&data, day: $0)
        }
    }
    
    public func lineDataSet(_ data: [Any]) -> [LineChartDataSet]? {
        guard let data = data as? [KLineData] else {
            return nil }

        let sets = days.compactMap { (day) -> LineChartDataSet in
            var entries = data.compactMap{ (d) -> ChartDataEntry? in
                if let value = d.mavol?.data[day] as? Double {
                    return ChartDataEntry(x: d.x, y: value)
                } else {
                    return nil
                }
            }
            if entries.count == 0, let d = data.first {
                entries.append(ChartDataEntry(x: d.x, y: d.open))
            }
            let last = entries.last?.y ?? 0
            let label = String(format: "MAVOL\(day):%.2f", last)
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
    
    public func barDataSet(_ data: [Any]) -> [BarChartDataSet]? {
        guard let data = data as? [KLineData] else { return nil }
        
        var colors = [UIColor]()
        let entries = data.compactMap{ (model) -> BarChartDataEntry in
            colors.append( model.open >= model.close ? style.upBarColor : style.downBarColor)
            return BarChartDataEntry(x: model.x, y: model.open)
        }
        
        let set = BarChartDataSet(entries: entries)
        set.colors = colors
        set.valueColors = colors
        set.drawValuesEnabled = false
        
        return [set]
    }
    
    
    
}
