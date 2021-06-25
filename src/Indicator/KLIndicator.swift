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

    /// 默认true，判断是否需要计算该数据，防止在section改变的情况下对已经计算过的数据重新计算，浪费资源
    static func needCalculate(_ data: inout [Any]) -> Bool

    func candleDataSet(_ data: [Any]) -> [CandleChartDataSet]?
    func lineDataSet(_ data: [Any]) -> [LineChartDataSet]?
    func barDataSet(_ data: [Any]) -> [BarChartDataSet]?

}

extension KLIndicator {

    public static func calculate(_ data: inout [Any]) {}

    public static func needCalculate(_ data: inout [Any]) -> Bool { return true }

    public func candleDataSet(_ data: [Any]) -> [CandleChartDataSet]? { return nil }
    public func lineDataSet(_ data: [Any]) -> [LineChartDataSet]? { return nil }
    public func barDataSet(_ data: [Any]) -> [BarChartDataSet]? { return nil }

    public var style: KLStyle { return Self.style }

    public static var name: String { return "\(Self.self)" }
    public var name: String { return Self.name }

}

