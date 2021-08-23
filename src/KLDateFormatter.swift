//
//  KLDateFormatter.swift
//  KLine
//
//  Created by pikacode on 2021/6/21.
//

import UIKit
import Charts

open class KLEmptyFormatter: IAxisValueFormatter {
    public init() {

    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return ""
    }

}

open class KLDateFormatter: IAxisValueFormatter {

    public let formatter: DateFormatter

    public init(_ formatter: DateFormatter) {
        self.formatter = formatter
    }

    open func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = Date(timeIntervalSince1970: value * KLineData.timeXScale)
        return formatter.string(from: date)
    }

}
open class KLDepthFormatter: IAxisValueFormatter {

    let priceArr: [String]

    public init(_ priceArr: [String]) {
        self.priceArr = priceArr
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard let string = priceArr[Int(value)~]  else {
            return ""
        }
        return string
    }

}

