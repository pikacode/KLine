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

    let combinedData = CombinedChartData()

    func draw(_ data: [KLineData]) {
        self.data = data
         
        let lineData = LineChartData()
        let candleData = CandleChartData()
        let barData = BarChartData()

        indicators.forEach {
            if let line = $0.lineData(data) {
                lineData.dataSets.append(contentsOf: line)
                combinedData.lineData = lineData
            }
            if let bar = $0.barData(data) {
                barData.dataSets.append(contentsOf: bar)
                combinedData.barData = barData
            }
            if let candle = $0.candleData(data) {
                candleData.dataSets.append(contentsOf: candle)
                combinedData.candleData = candleData
            }
        }
        
        chartView.data = combinedData
        chartView.viewPortHandler.setMaximumScaleX(10)

        if combinedData.lineData != nil || combinedData.barData != nil || combinedData.candleData != nil {
            chartView.zoomToCenter(scaleX: 10, scaleY: 1)
        }
    }

}
