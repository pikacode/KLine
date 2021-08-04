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
        v.leftYAxisRenderer = KLYAxisRenderer(viewPortHandler: v.viewPortHandler, axis: v.leftAxis, transformer: v.getTransformer(forAxis: .left))
        v.rightYAxisRenderer = KLYAxisRenderer(viewPortHandler: v.viewPortHandler, axis: v.rightAxis, transformer: v.getTransformer(forAxis: .right))
        return v
    }()

    open var height: CGFloat

    open var markView: UIView? {
        didSet {
            if let markView = markView {
                chartView.klMarker = KLMarker(view: markView, chartView: chartView)
            } else {
                chartView.klMarker = nil
            }
        }
    }

    open var data = [Any]() {
        didSet {
            draw()
        }
    }

    open var showCrosshair = true {
        didSet {
            chartView.showCrosshair = showCrosshair
        }
    }

    var offset: CGFloat = 0

    public var xAxis: XAxis { chartView.xAxis }
    public var leftAxis: YAxis { chartView.leftAxis }
    public var rightAxis: YAxis { chartView.rightAxis }
    public var xValueFormatter: Charts.AxisValueFormatter? {
        get { return xAxis.valueFormatter }
        set { xAxis.valueFormatter = newValue }
    }

    /// only draw data
    open func draw() {

        /// 画 limit line
        removeLimitLines()

        indicators.forEach{
            if let l = $0 as? LimitLine {
                let line = l.limitLine
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

        if combinedData.lineData != nil || combinedData.barData != nil || combinedData.candleData != nil {
            chartView.data = combinedData
            if visibleXMaxCountReal != visibleXMaxCount {
                //设置多次会有bug
                visibleXMaxCountReal = visibleXMaxCount
                chartView.setVisibleXRangeMaximum(visibleXMaxCount)
            }
            chartView.setScaleMinima(1.5, scaleY: 1)
//            if data.count < 52, let max = chartView.data?.dataSets.first?.xMax, let min = chartView.data?.dataSets.first?.xMin, max > min, min.isFinite, min != Double.greatestFiniteMagnitude {
//                let n = (max - min)/Double(data.count)
//                chartView.xAxis.axisMaximum = n * 52 + min
//            }
        }

        chartView.viewPortHandler.setMaximumScaleX(20)

        chartView.xAxis.spaceMin = 5
//        chartView.leftAxis.spaceMin = 3
//        chartView.rightAxis.spaceMin = 20
//        if chartView.chartYMax != .infinity && chartView.chartYMax != .nan {
//            chartView.xAxis.spaceMax = 8
//        } else {
            //chartView.xAxis.spaceMax = 3
//        }
        if combinedData.candleData != nil {
            chartView.changeCrosshair(chartView.crosshair.point, force: true)
        }

    }

    //except Crosshair
    open func removeLimitLines() {
        leftAxis.limitLines.enumerated().forEach{
            if !$0.element.isCrosshair {
                leftAxis.removeLimitLine($0.element)
            }
        }
        rightAxis.limitLines.enumerated().forEach{
            if !$0.element.isCrosshair {
                rightAxis.removeLimitLine($0.element)
            }
        }
        xAxis.limitLines.enumerated().forEach{
            if !$0.element.isCrosshair {
                xAxis.removeLimitLine($0.element)
            }
        }
    }

    open func crosshairLines() -> [LimitLine] {
        return indicators.compactMap {
            if let l = $0 as? LimitLine, l.isCrosshair {
                return l
            } else {
                return nil
            }
        }
    }

    open var visibleXMaxCount: Double = 52
    var visibleXMaxCountReal: Double = 0

}
