//
//  KDJ.swift
//  KLine
//
//  Created by aax1 on 2021/6/18.
//

import UIKit
import Charts

open class KDJ {

    required public init() {}
    
    public static var days = [9, 3, 3]
    var days: [Int] { return Self.days }
    
    public static var calculate_period: Int = 9 //计算周期
    public static var ma1_period: Int = 3 //移动平均周期1
    public static var ma2_period: Int = 3 //移动平均周期2
    public enum KDJType{
        case K
        case D
        case J
    }
    public static var macd_type: [KDJType] = [.K, .D, .J]
    
    //KDJ技术指标
    var k: Double = 0.0
    var d: Double = 0.0
    var j: Double = 0.0
    var rsv: Double = 0.0

        /**
     三根线：K，D，J
     以最高价，最低价和收盘价为基本数据进行计算
     1）先计算周期（n日，n周）的RSV值（RSV：未成熟随机指标值，值范围1–100）

     2）若无前一日K 值与D值，则可分别用50来代替。
         当日K值=2÷3×前一日K值＋1÷3×当日RSV
         当日D值=2÷3×前一日D值＋1÷3×当日K值
     3）J值=3×当日D值-2×当日K值
     */
    private static func calculateKDJ(_ data: inout [KLineData]) {
       
        for i in 0 ..< data.count {
            let model = data[i].kdj ?? KDJ()
            if i == 0 {
                model.k = 50
                model.d = 50
            } else {
                let lastModel = data[i - 1].kdj ?? KDJ()
                model.rsv = calculateRSV(endIndex: i, data: data)
                model.k = (2 * lastModel.k + model.rsv) / Double(ma1_period)
                model.d = (2 * lastModel.d + model.k) / Double(ma2_period)
            }
            model.j = 3 * model.d - 2 * model.k
            data[i].kdj =  model
        }
    }
    
     /**
        计算周期（n日，n周）的RSV值
        n日RSV=（Cn－Ln）÷（Hn－Ln）×100
        cn：第N日的收盘价
        Ln：N日内最低价
        Hn：N日内最高价
     */
    private static func calculateRSV(endIndex: Int, data: [KLineData]) -> Double {
        var Ln = Double(MAXFLOAT)
        var Hn = Double(-MAXFLOAT)
        let cn: Double = data[endIndex].close
        var startIndex = endIndex - (calculate_period - 1)
        if startIndex < 0 {
            startIndex = 0
        }
        for index in startIndex...endIndex {
            let model = data[index]
            if model.low < Ln {
                Ln = model.low
            }
            if model.high > Hn {
                Hn = model.high
            }
        }
        let result: Double = (cn - Ln) / (Hn - Ln) * 100.0
        return result.isNaN ? 0 : result
    }
    
}

extension KDJ: KLIndicator {

    public static var style: KLStyle = KLStyle.default
    public static func calculate(_ data: inout [Any]) {
        guard var data = data as? [KLineData] else { return }
        calculateKDJ(&data)
    }

    public func lineDataSet(_ data: [Any]) -> [LineChartDataSet]? {
        guard let data = data as? [KLineData] else { return nil }

        var sets = [LineChartDataSet]()
        
        for (index, type) in KDJ.macd_type.enumerated() {
            let entries = data.compactMap{ (model) -> ChartDataEntry? in
                let kdj = model.kdj ?? KDJ()
                var yValue: Double = 0
                switch type {
                case .K:
                    yValue = kdj.k
                case .D:
                    yValue = kdj.d
                case .J:
                    yValue = kdj.j
                }
                return ChartDataEntry(x: model.x, y: yValue)
            }
            
            let yValue = entries.last?.y ?? 0
            var label = ""
            switch type {
            case .K:
                label = String(format: "KDJ(\(KDJ.calculate_period),\(KDJ.ma1_period),\(KDJ.ma2_period) K:%.2f ",yValue)
            case .D:
                label = String(format: " D:%.2f ",yValue)
            case .J:
                label = String(format: " J:%.2f ",yValue)
                
            }
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
