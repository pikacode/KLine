//
//  KDJ.swift
//  KLine
//
//  Created by aax1 on 2021/6/18.
//

import UIKit
import Charts

open class KDJ {

    public static var days = [9, 3, 3]

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
            let model = data[i]
            if i == 0 {
                model.k = 50
                model.d = 50
            } else {
                let lastModel = data[i - 1]
                model.rsv = calculateRSV(endIndex: i, data: data)
                
                let kArg = days.firstIndex(of: 1) ?? 3
                let dArg = days.firstIndex(of: 2) ?? 3
                model.k = (2 * lastModel.k + model.rsv) / Double(kArg)
                model.d = (2 * lastModel.d + model.k) / Double(dArg)
            }
            model.j = 3 * model.d - 2 * model.k
            data[i] =  model
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
        let rsvArg: Int = days.first ?? 9
        var startIndex = endIndex - (rsvArg - 1)
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

    public static func calculate(_ data: inout [KLineData]) {
        calculateKDJ(&data)
    }

    public static func lineDataSet(_ data: [KLineData]) -> [LineChartDataSet]? {
        var sets = [LineChartDataSet]()
        for (index, _) in days.enumerated() {
            let entries = data.compactMap{ (d) -> ChartDataEntry? in
                return ChartDataEntry(x: d.x, y: index == 0 ? d.k : index == 1 ? d.d : d.j)
            }
            let labelArr = ["K", "D", "J"]
            var lable = String(format: "\(labelArr[index]):%.2f ", entries.last?.y ?? 0)
            if index == 0 {
                lable = "KDJ\(days.map{String($0)}.joined(separator: ","))  \(lable)"
            }
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
