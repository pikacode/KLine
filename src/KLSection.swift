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

    var offset: CGFloat = 0

    public var xAxis: XAxis { chartView.xAxis }
    public var leftAxis: YAxis { chartView.leftAxis }
    public var rightAxis: YAxis { chartView.rightAxis }

    open func draw() {

        /// 画 limit line
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
            chartView.data = nil
            return
        }

        let combinedData = CombinedChartData()
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

        chartView.viewPortHandler.setMaximumScaleX(20)

        chartView.xAxis.spaceMin = 2
        if chartView.chartYMax != .infinity && chartView.chartYMax != .nan {
            chartView.xAxis.spaceMax = Double("\(Int(chartView.chartYMax))".count) * 2
        } else {
            chartView.xAxis.spaceMax = 10
        }

        if combinedData.lineData != nil || combinedData.barData != nil || combinedData.candleData != nil {
            
            chartView.data = combinedData

            chartView.setVisibleXRangeMaximum(52)
            chartView.setScaleMinima(1.5, scaleY: 1)
            if data.count < 52 {
                let n = (chartView.xAxis.axisMaximum - chartView.xAxis.axisMinimum)/Double(data.count)
                chartView.xAxis.axisMaximum = n * 52 + chartView.xAxis.axisMinimum
            }
        }

    }

}
