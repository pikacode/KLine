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
    public static var days = [6, 12, 24]
    
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
    
    private static func calculateRSI(_ data: inout [KLineData]) {
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
        let lastRsi = model.rsi ?? RSI()
        
        let min_avg = Double(days[0])
        let mid_avg = Double(days[1])
        let max_avg = Double(days[2])
        
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
        for (index, day) in RSI.days.enumerated() {
            let entries = data.compactMap{ (d) -> ChartDataEntry? in
                let rsi = d.rsi ?? RSI()
                return ChartDataEntry(x: d.x, y: index == 0 ? rsi.rsi6 : index == 1 ? rsi.rsi12 : rsi.rsi24)
            }
            
            let lable = String(format: "RSI(\(day)):%.2f", entries.last?.y ?? 0)
            let set = LineChartDataSet(entries: entries, label: lable)
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
