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
        case up
        case mb
        case down
    }
    public static var boll_type: [BollType] = [.up, .mb, .down]
    
    var mb_boll: Double = 0
    var up_boll: Double = 0
    var dn_boll: Double = 0

    private static func calculateBOLL(_ data: inout [KLineData]) {
        
        if data.count < boll_day {
            return
        }
        
        for i in boll_day - 1 ..< data.count {
            let boll = data[i].boll ?? BOLL()
            boll.mb_boll = calculateAveragePrice(index: i, data: &data)
            let md = calculateMD(index: i, data: &data)
            boll.up_boll = boll.mb_boll + (md * Double(boll_average))
            boll.dn_boll = boll.mb_boll - (md * Double(boll_average))
            data[i].boll = boll
        }
        
        
    }
    //平均线
    static func calculateAveragePrice(index: Int, data: inout [KLineData]) -> Double{
        let day = boll_day - 1
        if index < day  { return 0 }
        var sum: Double = 0
        for i in index - day ... index {
            let model = data[i]
            sum += model.close
        }
        
        return sum / Double(boll_day)
        
    }
    //标准差
    static func calculateMD(index: Int, data: inout [KLineData]) -> Double{
        
        let day = boll_day - 1
        let avg = boll_average
        
        if index < day { return 0}
        var daya = boll_day
        
        var sum: Double = 0
        for i in index - day ... index  {
            let model = data[i]
            let boll = data[i].boll ?? BOLL()
            if boll.mb_boll == 0 {
                daya -= 1
            }else{
                sum += pow(model.close - boll.mb_boll, Double(avg))
            }
        }
        return sqrt(sum / Double(daya))
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
        
        for (index, type) in BOLL.boll_type.enumerated() {
            let entries = data.compactMap { (model) -> ChartDataEntry? in
                let boll = model.boll ??  BOLL()
                let bollValue = type == .mb ? boll.mb_boll : type == .up ? boll.up_boll : boll.dn_boll
                if bollValue == 0 { return nil}
                return ChartDataEntry(x: model.x, y: bollValue)
            }
            
            let set = LineChartDataSet(entries: entries)
            let color = [style.lineColor1, style.lineColor2, style.lineColor3][index]
            set.setColor(color)
            set.lineWidth = style.lineWidth1
            set.circleRadius = 0
            set.circleHoleRadius = 0
            set.mode = .cubicBezier
            set.drawValuesEnabled = false
            set.axisDependency = .left
            sets.append(set)
            
        }
        
        return sets
    }
}
