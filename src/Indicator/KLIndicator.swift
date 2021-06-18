//
//  KLIndicator.swift
//  KLine
//
//  Created by pikacode on 2021/6/15.
//

import UIKit
import Charts

public protocol KLIndicator {
    static func calculate(_ data: inout [KLineData])

    // to handle custom data
    static func calculate(custom data: inout [Any])

    static var style: KLStyle { get set }

    static func candleDataSet(_ data: [KLineData]) -> [CandleChartDataSet]?
    static func lineDataSet(_ data: [KLineData]) -> [LineChartDataSet]?
    static func barDataSet(_ data: [KLineData]) -> [BarChartDataSet]?

    static func candleDataSet(custom data: [Any]) -> [CandleChartDataSet]?
    static func lineDataSet(custom data: [Any]) -> [LineChartDataSet]?
    static func barDataSet(custom data: [Any]) -> [BarChartDataSet]?

    static func lineDataSet(points data: [KLPoint]) -> [LineChartDataSet]?

}

extension KLIndicator {
    public static var name: String { return "\(self)" }

    public static func calculate(_ data: inout [KLineData]) {

    }

    public static func calculate(custom data: inout [Any]) {

    }

    public static func candleDataSet(_ data: [KLineData]) -> [CandleChartDataSet]? {
        return nil
    }

    public static func lineDataSet(_ data: [KLineData]) -> [LineChartDataSet]? {
        return nil
    }

    public static func barDataSet(_ data: [KLineData]) -> [BarChartDataSet]? {
        return nil
    }

    public static func candleDataSet(custom data: [Any]) -> [CandleChartDataSet]? {
        return nil
    }

    public static func lineDataSet(custom data: [Any]) -> [LineChartDataSet]? {
        return nil
    }

    public static func barDataSet(custom data: [Any]) -> [BarChartDataSet]? {
        return nil
    }

    public static func lineDataSet(points data: [KLPoint]) -> [LineChartDataSet]? {
        return nil
    }

}
