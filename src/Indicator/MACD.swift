//
//  MACD.swift
//  KLine
//
//  Created by aax1 on 2021/6/17.
//

import UIKit
import Charts

open class MACD {

    required public init() {}
    
    public enum MacdType{
        case dif
        case dea
        case macd
    }
    public static var macd_type: [MacdType] = [.dif, .dea, .macd]
    
    public static var short_period: Int = 12 //短周期
    public static var long_period: Int = 26 //长周期
    public static var ma_period: Int = 9 //移动平均周期
    
    public var dif: Double = 0
    public var dea: Double = 0
    public var macd: Double = 0
    var longEma: Double = 0
    var shortEma: Double = 0

    /**
     EMA（12）= 前一日EMA（12）×11/13＋今日收盘价×2/13
     EMA（26）= 前一日EMA（26）×25/27＋今日收盘价×2/27
     DIFF=今日EMA（12）- 今日EMA（26）
     DEA（MACD）= 前一日DEA×8/10＋今日DIF×2/10
     BAR=2×(DIFF－DEA)
     */
    static func calculateMACD(_ data: inout [KLineData]) {
        
        let short = Double(short_period)
        let long =  Double(long_period)
        let ma =  Double(ma_period)
        
        for i in 0..<data.count {
            let model = data[i]
            let macd = model.macd ?? MACD()
            
            //计算EMA12，EMA26, DEA
            if i == 0 {
                macd.longEma = model.close
                macd.shortEma = model.close
                macd.dif = 0
                macd.dea = 0
            } else {
                let lastMacd = data[i - 1].macd ?? MACD()
                macd.shortEma = lastMacd.shortEma
                macd.shortEma = lastMacd.shortEma * (short - 1.0) / (short + 1.0) +  model.close * 2.0 / (short + 1.0)
                macd.longEma = lastMacd.longEma * (long - 1.0) / (long + 1.0) + model.close * 2.0 / (long + 1.0)
                macd.dif =  macd.shortEma - macd.longEma
                macd.dea  = lastMacd.dea * (ma - 1.0) / (ma + 1.0) + macd.dif * 2.0 / (ma + 1.0)
            }
            macd.macd = 2 * (macd.dif - macd.dea)
            data[i].macd = macd
        }
    }
    
    
    
}

extension MACD: KLIndicator {
    
    public static var style: KLStyle = KLStyle.default
    public static func calculate(_ data: inout [Any]) {
        guard var data = data as? [KLineData] else { return }
        calculateMACD(&data)
    }

    public func lineDataSet(_ data: [Any]) -> [LineChartDataSet]? {
        guard let data = data as? [KLineData] else { return nil }
        var sets = [LineChartDataSet]()
        for (index, type) in MACD.macd_type.enumerated() {
            if type == .macd { break}
            let entries = data.compactMap{ (model) -> ChartDataEntry? in
                let macd = model.macd ?? MACD()
                return ChartDataEntry(x: model.x, y: type == .dif ? macd.dif : macd.dea)
            }
            var label = ""
            if index == 0 {
                label = "MACD(\(MACD.short_period),\(MACD.long_period),\(MACD.ma_period))"
            }
            label += type == .dea ? String(format: " DEA:%.2f",entries.last?.y ?? 0) : String(format: " DIF:%.2f",entries.last?.y ?? 0)
            
            let set = LineChartDataSet(entries: entries, label: label)
            let color = [style.lineColor1, style.lineColor2][index]
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

    public func barDataSet(_ data: [Any]) -> [BarChartDataSet]? {
        guard let data = data as? [KLineData] else { return nil }
        if !MACD.macd_type.contains(.macd) { return nil }
        var colors = [UIColor]()
        let entries = data.compactMap{ (model) -> BarChartDataEntry in
            let macd = model.macd ?? MACD()
            colors.append(macd.macd > 0 ? style.upBarColor : style.downBarColor)
            return BarChartDataEntry(x: model.x, y: macd.macd)
        }
        let label = String(format: " MACD:%.2f",entries.last?.y ?? 0)
        let set = BarChartDataSet(entries: entries, label: label)
        set.colors = colors
        set.drawValuesEnabled = false
        return [set]
    }
}
