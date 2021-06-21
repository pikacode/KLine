//
//  KLSection.swift
//  KLine
//
//  Created by pikacode on 2021/6/15.
//

import UIKit
import Charts

open class KLSection {

    public init(_ indicators: [KLIndicator], _ height: CGFloat) {
        self.indicators = indicators
        self.height = height
    }

    open var indicators: [KLIndicator] {
        didSet {
            draw()
        }
    }

    open lazy var chartView: KLCombinedChartView = {
        let v = KLCombinedChartView(frame: .zero)
        v.xAxis.valueFormatter = KLEmptyFormatter()
        return v
    }()

    open var height: CGFloat

    open var data = [Any]() {
        didSet {
            draw()
        }
    }

    public let combinedData = CombinedChartData()

    var offset: CGFloat = 0

    public var xAxis: XAxis { chartView.xAxis }
    public var leftAxis: YAxis { chartView.leftAxis }
    public var rightAxis: YAxis { chartView.rightAxis }

    open func draw() {

        guard data.count > 0 else {
            indicators.forEach{
                if let l = $0 as? LimitLine {
                    let line = ChartLimitLine(limit: Double(l.value), label: "开仓")
                    line.lineWidth = 1
                    line.lineDashLengths = [5, 5]
                    line.labelPosition = .topRight
                    line.valueFont = .systemFont(ofSize: 10)
                    let leftAxis = chartView.leftAxis
                    leftAxis.removeAllLimitLines()
                    leftAxis.addLimitLine(line)
                    leftAxis.gridLineDashLengths = [5, 5]
                }
            }
            return
        }

        let lineData = LineChartData()
        let candleData = CandleChartData()
        let barData = BarChartData()

        indicators.forEach {
            if let set = $0.lineDataSet(data), set.count > 0 {
                lineData.dataSets.append(contentsOf: set)
                combinedData.lineData = lineData
            }
            if let set = $0.barDataSet(data), set.count > 0 {
                barData.dataSets.append(contentsOf: set)
                combinedData.barData = barData
            }
            if let set = $0.candleDataSet(data), set.count > 0 {
                candleData.dataSets.append(contentsOf: set)
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
