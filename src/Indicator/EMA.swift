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
    
    public enum EMAType{
        case short(Int) //短线
        case mid(Int)  //中线
        case long(Int) //长线
    }
    public static var emaDays:[EMAType] = [.short(7), .mid(25), .long(99)]
    
    public var short_ema: Double = 0
    public var mid_ema: Double = 0
    public var long_ema: Double = 0
    
    
    static func calculateEMA(_ data: inout [KLineData]) {
        
        for i in 0 ..< data.count {
            let model = data[i]
            let ema = data[i].ema ?? EMA()
            if i == 0 {
                //第一天的ema12 是收盘价
                ema.short_ema = model.close
                ema.mid_ema = model.close
                ema.long_ema = model.close
                
            } else {
                let lastEma = data[i - 1].ema ?? EMA()
                for type in emaDays {
                    switch type {
                    case .short(let day):
                        ema.short_ema =  (2 / Double(day + 1)) * (model.close - lastEma.short_ema) + lastEma.short_ema
                    case .mid(let day):
                        ema.mid_ema =  (2 / Double(day + 1)) * (model.close - lastEma.mid_ema) + lastEma.mid_ema
                    case .long(let day):
                        ema.long_ema =  (2 / Double(day + 1)) * (model.close - lastEma.long_ema) + lastEma.long_ema
                    }
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
            self.calculateEMA(&data)
    }

    public func lineDataSet(_ data: [Any]) -> [LineChartDataSet]? {
        guard let data = data as? [KLineData] else { return nil }

        var sets = [LineChartDataSet]()
        var label: String = ""
        for (index, type) in EMA.emaDays.enumerated() {
            let entries = data.compactMap{ (model) -> ChartDataEntry? in

                let ema = model.ema ?? EMA()
                var emaDay: Int = 0
                var emaValue: Double = 0
                
                
                switch type {
                case .short(let day):
                    emaDay = day
                    emaValue = ema.short_ema
                case .mid(let day):
                    emaDay = day
                    emaValue = ema.mid_ema
                case .long(day: let day):
                    emaDay = day
                    emaValue = ema.long_ema
                }
                if emaDay == 0{ return nil}
                label =  String(format:"EMA(\(emaDay)):%.2f",emaValue)
                return ChartDataEntry(x: model.x, y: emaValue)
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
