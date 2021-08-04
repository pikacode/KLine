//
//  KLDateFormatter.swift
//  KLine
//
//  Created by pikacode on 2021/6/21.
//

import UIKit
import Charts

open class KLEmptyFormatter: AxisValueFormatter {
    public init() {

    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return ""
    }

}

open class KLDateFormatter: AxisValueFormatter {

    let formatter: DateFormatter

    public init(_ formatter: DateFormatter) {
        self.formatter = formatter
    }

    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = Date(timeIntervalSince1970: value * KLineData.timeXScale)
        return formatter.string(from: date)
    }

}
