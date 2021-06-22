//
//  KLIndicator.swift
//  KLine
//
//  Created by pikacode on 2021/6/15.
//

import UIKit
import Charts

public protocol KLIndicator {

    init()

    static var style: KLStyle { get set }

    /// data is [KLineData] or custom data
    static func calculate(_ data: inout [Any])

    func candleDataSet(_ data: [Any]) -> [CandleChartDataSet]?
    func lineDataSet(_ data: [Any]) -> [LineChartDataSet]?
    func barDataSet(_ data: [Any]) -> [BarChartDataSet]?

}

extension KLIndicator {

    public static func calculate(_ data: inout [Any]) {}

    public func candleDataSet(_ data: [Any]) -> [CandleChartDataSet]? { return nil }
    public func lineDataSet(_ data: [Any]) -> [LineChartDataSet]? { return nil }
    public func barDataSet(_ data: [Any]) -> [BarChartDataSet]? { return nil }

    public var style: KLStyle { return Self.style }

}

public protocol Init {
    init()
}

//extension KLIndicator: Init {
//
//}
