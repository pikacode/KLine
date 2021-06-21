//
//  KLDateFormatter.swift
//  KLine
//
//  Created by pikacode on 2021/6/21.
//

import UIKit
import Charts

open class KLEmptyFormatter: IAxisValueFormatter {

    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return ""
    }

}

open class KLDateFormatter: IAxisValueFormatter {

    public init() {

    }

    public static var format = "yyyy-MM-dd" {
        didSet{
            formatter.dateFormat = format
        }
    }

    static var formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = format
        return f
    }()

    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = Date(timeIntervalSince1970: value * KLineData.timeXScale)
        print("o: \(value) \(value * KLineData.timeXScale)")
        return KLDateFormatter.formatter.string(from: date)
    }

}
