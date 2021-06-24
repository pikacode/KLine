//
//  BOLL.swift
//  KLine
//
//  Created by aax1 on 2021/6/23.
//

import UIKit
import Charts


open class BOLL {
    required public init() {}
    
    //外部传进来的参数
    public static var boll_day: Int = 21 //参考天数
    public static var boll_average: Int = 2
    
    public enum BollType {
        case average
        case up
        case down
    }
    public static var boll_type: [BollType] = [.up, .average, .down]
    
    var avg_boll: Double = 0
    var up_boll: Double = 0
    var dn_boll: Double = 0

    private static func calculateBOLL(_ data: inout [KLineData]) {
        
        if data.count < boll_day {
            return
        }
        
        for i in 0 ..< data.count {
            let boll = data[i].boll ?? BOLL()
            boll.avg_boll = calculateAveragePrice(day: boll_day, index: i, data: &data)
            boll.up_boll = boll.avg_boll + calculateStd(day: boll_day, avg: boll_average, index: i, data: &data) * Double(boll_average)
            boll.dn_boll = boll.avg_boll - calculateStd(day: boll_day, avg: boll_average, index: i, data: &data) * Double(boll_average)
            data[i].boll = boll
        }
        
        
    }
    //平均线
    static func calculateAveragePrice(day: Int, index: Int, data: inout [KLineData]) -> Double{
        
        if index < day - 1 { return 0 }
        
        var sum: Double = 0
        
        for i in stride(from: index, to: day, by: -1) {
            let model = data[i]
            sum += model.close
        }
    
        return sum / Double(day)
        
    }
    //标准差
    static func calculateStd(day: Int, avg: Int, index: Int, data: inout [KLineData]) -> Double{
        if index < day - 1 { return 0}
        
        var sum: Double = 0
        var avg_boll: Double = 0
        
        for i in stride(from: index, to: day - 1, by: -1) {
            let model = data[i]
            let boll = data[i].boll ?? BOLL()
            if avg_boll == 0 {
                avg_boll = boll.avg_boll
            }
            sum += pow(model.close - avg_boll, Double(avg))
    
        }
        return sqrt(sum / Double(day))
        
    }
}

extension BOLL: KLIndicator {
    public static var style: KLStyle = KLStyle.default

    public static func calculate(_ data: inout [Any]) {
        guard var data = data as? [KLineData] else { return }
        BOLL.calculateBOLL(&data)
    }
    
    public  func lineDataSet(_ data: [Any]) -> [LineChartDataSet]? {
        guard let data = data as? [KLineData] else { return nil}
        var sets = [LineChartDataSet]()
        
        for (index, b) in BOLL.boll_type.enumerated() {
            let entries = data.compactMap { (model) -> ChartDataEntry? in
                let boll = model.boll ??  BOLL()
                return ChartDataEntry(x: model.x, y: b == .average ? boll.avg_boll : b == .up ? boll.up_boll : boll.dn_boll)
            }
            let label = ""
            let set = LineChartDataSet(entries: entries, label: label)
            let color = [style.lineColor1, style.lineColor2, style.lineColor3][index]
            set.setColor(color)
            set.lineWidth = style.lineWidth1
            set.circleRadius = 0
            set.circleHoleRadius = 0
            set.mode = .cubicBezier
            set.drawValuesEnabled = true
            set.axisDependency = .left
            sets.append(set)
            
        }
        
        return sets
    }
}
