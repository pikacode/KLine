//
//  Depth.swift
//  KLine
//
//  Created by aax1 on 2021/6/28.
//

import UIKit
import Charts
class Depth {
    required public init() {}
    

    private static func calculateDepth(_ data: inout [KLDepthPoint]){
    
        var sum: Double = 0.0
        var index: Int = 0
        
        for i in 0 ..< data.count {
            var model = data[i]
            sum += model.vol
            if index == i {
                index += 1
                model.depthNum = sum
                data[i] = model
                break
            }
        }
    }
}

extension Depth: KLIndicator {
    public static var style: KLStyle = KLStyle.default

    public static func calculate(_ data: inout [Any]) {
        guard var data = data as? [KLDepthPoint] else { return }
        calculateDepth(&data)
    }
    
    
    public func lineDataSet(_ data: [Any]) -> [LineChartDataSet]? {
        guard let data = data as? [KLDepthPoint] else { return nil }
        var sets = [LineChartDataSet]()
       
        let entries = data.compactMap{ (model) -> ChartDataEntry? in
            return ChartDataEntry(x: Double(model.x), y: model.depthNum)
        }
        let set = LineChartDataSet(entries: entries)
        let color = style.lineColor1
        set.setColor(color)
        set.lineWidth = style.lineWidth1
        set.circleRadius = 0
        set.circleHoleRadius = 0
        set.mode = .cubicBezier
        set.drawValuesEnabled = true
        set.axisDependency = .left
        sets.append(set)
        
        return sets
    }
    
    
    
}
