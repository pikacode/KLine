//
//  RSI.swift
//  KLine
//
//  Created by aax1 on 2021/6/18.
//

import UIKit
import Charts

open class RSI {

    required public init() {}
    public enum RSIType{
        case RSI1(Int)
        case RSI2(Int)
        case RSI3(Int)
    }
    public static var rsiDays:[RSIType] = [.RSI1(6), .RSI2(12), .RSI3(24)]
    //RSI指标参数
    var up_avg_6: Double   = 0
    var up_avg_12: Double  = 0
    var up_avg_24: Double  = 0
    var dn_avg_6: Double   = 0
    var dn_avg_12: Double  = 0
    var dn_avg_24: Double  = 0
    var rsi6: Double       = 0
    var rsi12: Double      = 0
    var rsi24: Double      = 0
    
    static var min_day: Int = 0
    static var mid_day: Int = 0
    static var max_day: Int = 0
    
    private static func calculateRSI(_ data: inout [KLineData]) {
        
        for type in rsiDays {
            switch type{
            case .RSI1(let day):
                 min_day = day
            case .RSI2(let day):
                mid_day = day
            case .RSI3(let day):
                max_day = day
            }
        }
        
        if data.count >= 5 {
            for i in 1 ..< data.count {
                    // 计算RS
                    let rsi = calculateSingleRS(index: i, data: data)
                    
                    // 计算RSI
                    let dn_avg_6 = (rsi.dn_avg_6 == 0) ? 1 : rsi.dn_avg_6
                    let dn_avg_12 = (rsi.dn_avg_12 == 0) ? 1 : rsi.dn_avg_12
                    let dn_avg_24 = (rsi.dn_avg_24 == 0) ? 1 : rsi.dn_avg_24
                
            
                    rsi.rsi6 = 100.0 - (100.0 / (1.0 + rsi.up_avg_6 / dn_avg_6))
                    rsi.rsi12  = 100.0 - (100.0 / (1.0 + rsi.up_avg_12 / dn_avg_12))
                    rsi.rsi24 = 100.0 - (100.0 / (1.0 + rsi.up_avg_24 / dn_avg_24))
                    
                    data[i].rsi = rsi
            }
        }
    }
    
    static func calculateSingleRS(index: Int, data: [KLineData]) -> RSI {
        
        let model = data[index]
        let lastModel = data[index - 1]
        
        let diff = model.close - lastModel.close
        let up: Double = fmax(0.0, diff)
        let dn: Double = abs(fmin(0.0, diff))
        
        let rsi = model.rsi ?? RSI()
        let lastRsi = lastModel.rsi ?? RSI()
        
        let min_avg = Double(RSI.min_day)
        let mid_avg = Double(RSI.mid_day)
        let max_avg = Double(RSI.max_day)
            
        if index == 1 {
            rsi.up_avg_6  = up / min_avg
            rsi.up_avg_12 = up / mid_avg
            rsi.up_avg_24 = up / max_avg

            rsi.dn_avg_6  = dn / min_avg
            rsi.dn_avg_12 = dn / mid_avg
            rsi.dn_avg_24 = dn / max_avg
        } else {
            rsi.up_avg_6  = (up / min_avg) + ((lastRsi.up_avg_6 * (min_avg - 1)) / min_avg)
            rsi.up_avg_12 = (up / mid_avg) + ((lastRsi.up_avg_12 * (mid_avg - 1)) / mid_avg)
            rsi.up_avg_24 = (up / max_avg) + ((lastRsi.up_avg_24 * (max_avg - 1)) / max_avg)

            rsi.dn_avg_6  = (dn / min_avg) + ((lastRsi.dn_avg_6 * (min_avg - 1)) / min_avg)
            rsi.dn_avg_12 = (dn / mid_avg) + ((lastRsi.dn_avg_12 * (mid_avg - 1)) / mid_avg)
            rsi.dn_avg_24 = (dn / max_avg) + ((lastRsi.dn_avg_24 * (max_avg - 1)) / max_avg)
        }
        
        return rsi
    }
}

extension RSI: KLIndicator{

    public static var style: KLStyle = KLStyle.default
    
    public static func calculate(_ data: inout [Any]) {
        guard var data = data as? [KLineData] else { return }
        RSI.calculateRSI(&data)
    }
    
    public func lineDataSet(_ data: [Any]) -> [LineChartDataSet]? {
        guard let data = data as? [KLineData] else { return nil }

        var sets = [LineChartDataSet]()
        var rsiDay: Int = 0
        for (index, type) in RSI.rsiDays.enumerated() {
            let entries = data.compactMap{ (model) -> ChartDataEntry? in
                let rsi = model.rsi ?? RSI()
                var yValue: Double = 0
                switch type{
                case .RSI1(let day):
                    rsiDay = day
                    yValue = rsi.rsi6
                case .RSI2(let day):
                    rsiDay = day
                    yValue = rsi.rsi12
                case .RSI3(let day):
                    rsiDay = day
                    yValue = rsi.rsi24
                }
                
                return ChartDataEntry(x: model.x, y: yValue)
                
            }
            
            let lable = String(format: "RSI(\(rsiDay)):%.\(KLineView.precision)f", entries.last?.y ?? 0)
            let set = LineChartDataSet(entries: entries, label: lable)
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
