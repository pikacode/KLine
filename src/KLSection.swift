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
        v.leftYAxisRenderer = KLYAxisRenderer(viewPortHandler: v.viewPortHandler, yAxis: v.leftAxis, transformer: v.getTransformer(forAxis: .left))
        v.rightYAxisRenderer = KLYAxisRenderer(viewPortHandler: v.viewPortHandler, yAxis: v.rightAxis, transformer: v.getTransformer(forAxis: .right))
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

        leftAxis.removeAllLimitLines()
        rightAxis.removeAllLimitLines()
        xAxis.removeAllLimitLines()
        indicators.forEach{
            if let l = $0 as? LimitLine {
                let line = KLChartLimitLine(limit: Double(l.value), label: l.label.text)
                line.lineWidth = l.lineWidth
                line.lineDashLengths = l.dashLengths
                line.labelPosition = .topLeft
                line.valueFont = l.label.font
                line.lineColor = l.lineColor
                line.valueTextColor = l.label.color
                line.bgColor = l.label.bgColor
                line.yOffset = -6
                if l.direction == .horizontal {
                    leftAxis.addLimitLine(line)
                    rightAxis.addLimitLine(line)
                } else {
                    xAxis.addLimitLine(line)
                }
            }
        }

        guard data.count > 0 else {
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
