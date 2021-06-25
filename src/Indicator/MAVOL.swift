//
//  MAVOL.swift
//  KLine
//
//  Created by pikacode on 2021/6/22.
//

import UIKit
import Charts
open class MAVOL {
    required public init() {

    }
        
}

extension MAVOL: KLIndicator {
    public static var style: KLStyle = KLStyle.default
   
    public static func calculate(_ data: inout [Any]) {
        
    }
    
    public func barDataSet(_ data: [Any]) -> [BarChartDataSet]? {
        guard let data = data as? [KLineData] else { return nil }
        
        var colors = [UIColor]()
        let entries = data.compactMap{ (model) -> BarChartDataEntry in
            colors.append( model.open >= model.close ? style.upBarColor : style.downBarColor)
            return BarChartDataEntry(x: model.x, y: model.vol)
        }

        let set = BarChartDataSet(entries: entries)
        set.colors = colors
        set.valueColors = colors
        set.drawValuesEnabled = false
        
        return [set]
    }
    
    
    
}
