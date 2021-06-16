//
//  KLSection.swift
//  KLine
//
//  Created by pikacode on 2021/6/15.
//

import UIKit
import Charts

open class KLSection {

    public var indicators: [KLIndicator.Type] {
        didSet {
            draw(data)
        }
    }

    public var height: CGFloat

    var offset: CGFloat = 0

    var data = [KLineData]()

    public init(_ indicators: [KLIndicator.Type], _ height: CGFloat) {
        self.indicators = indicators
        self.height = height
    }

    public lazy var chartView = KLCombinedChartView(frame: .zero)

    func draw(_ data: [KLineData]) {
        self.data = data

        let lineData = LineChartData()
        let candleData = CandleChartData()
        let barData = BarChartData()
        
        indicators.forEach {
            if let line = $0.lineData(data) {
                lineData.dataSets.append(line)
            }
            if let bar = $0.barData(data) {
                barData.dataSets.append(bar)
            }
            if let candle = $0.candleData(data) {
                candleData.dataSets.append(candle)
            }
        }

        let combinedData = CombinedChartData()
        combinedData.lineData = lineData
        combinedData.candleData = candleData
        combinedData.barData = barData
        chartView.data = combinedData

    }

}
