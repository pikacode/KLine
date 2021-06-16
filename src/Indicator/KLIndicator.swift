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

    static var style: KLStyle { get set }

    static func candleData(_ data: [KLineData]) -> CandleChartDataSet?
    static func lineData(_ data: [KLineData]) -> LineChartDataSet?
    static func barData(_ data: [KLineData]) -> BarChartDataSet?
}

extension KLIndicator {
    static var name: String { return "\(self)" }

    public static func candleData(_ data: [KLineData]) -> CandleChartDataSet? {
        return nil
    }

    public static func lineData(_ data: [KLineData]) -> LineChartDataSet? {
        return nil
    }

    public static func barData(_ data: [KLineData]) -> BarChartDataSet? {
        return nil
    }
}
