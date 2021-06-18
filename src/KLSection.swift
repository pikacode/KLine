//
//  KLSection.swift
//  KLine
//
//  Created by pikacode on 2021/6/15.
//

import UIKit
import Charts

open class KLSection {

    public init(_ indicators: [KLIndicator.Type], _ height: CGFloat) {
        self.indicators = indicators
        self.height = height
    }

    open var indicators: [KLIndicator.Type] {
        didSet {
            draw(data)
        }
    }

    open lazy var chartView = KLCombinedChartView(frame: .zero)

    open var height: CGFloat

    open var data = [Any]()

    public let combinedData = CombinedChartData()

    var offset: CGFloat = 0

    open func draw(_ data: [Any]) {
        self.data = data

        let lineData = LineChartData()
        let candleData = CandleChartData()
        let barData = BarChartData()

        indicators.forEach {
            if let data = data as? [KLineData] {
                if let line = $0.lineDataSet(data) {
                    lineData.dataSets.append(contentsOf: line)
                    combinedData.lineData = lineData
                }
                if let bar = $0.barDataSet(data) {
                    barData.dataSets.append(contentsOf: bar)
                    combinedData.barData = barData
                }
                if let candle = $0.candleDataSet(data) {
                    candleData.dataSets.append(contentsOf: candle)
                    combinedData.candleData = candleData
                }
            } else {
                if let line = $0.lineDataSet(custom: data) {
                    lineData.dataSets.append(contentsOf: line)
                    combinedData.lineData = lineData
                }
                if let bar = $0.barDataSet(custom: data) {
                    barData.dataSets.append(contentsOf: bar)
                    combinedData.barData = barData
                }
                if let candle = $0.candleDataSet(custom: data) {
                    candleData.dataSets.append(contentsOf: candle)
                    combinedData.candleData = candleData
                }
            }
        }

        chartView.data = combinedData
        chartView.viewPortHandler.setMaximumScaleX(10)

        if combinedData.lineData != nil || combinedData.barData != nil || combinedData.candleData != nil {
            chartView.zoomToCenter(scaleX: 10, scaleY: 1)
        }

    }

}
