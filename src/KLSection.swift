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
        v.xAxisRenderer = KLXAxisRenderer(viewPortHandler: v.viewPortHandler, xAxis: v.xAxis, transformer: v.getTransformer(forAxis: .left))
        v.leftYAxisRenderer = KLYAxisRenderer(viewPortHandler: v.viewPortHandler, yAxis: v.leftAxis, transformer: v.getTransformer(forAxis: .left))
        v.rightYAxisRenderer = KLYAxisRenderer(viewPortHandler: v.viewPortHandler, yAxis: v.rightAxis, transformer: v.getTransformer(forAxis: .right))
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

    weak var delegate: KLineView?

    public var xAxis: XAxis { chartView.xAxis }
    public var leftAxis: YAxis { chartView.leftAxis }
    public var rightAxis: YAxis { chartView.rightAxis }
    public var xValueFormatter: Charts.IAxisValueFormatter? {
        get { return xAxis.valueFormatter }
        set { xAxis.valueFormatter = newValue }
    }

    public var drawVerticalCrosshairLabel: Bool {
        set {
            chartView.crosshair._vertical.limitLine.drawLabelEnabled = newValue
        }
        get {
            return chartView.crosshair._vertical.limitLine.drawLabelEnabled
        }
    }

    open func drawLimitLines() {
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
    }

    /// only draw data
    open func draw() {

        drawLimitLines()

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
            if let da = delegate {
                chartView.customLegend(item: $0, lineData: da.data.last as! KLineData, section: self, first: true)
            }
        }

        chartView.xAxis.spaceMin = 4

        if data.count >= visibleXMaxCount {
            chartView.xAxis.spaceMax = 8
        } else {
            chartView.xAxis.spaceMax = Double(visibleXMaxCount - data.count - 2)
        }
        
        if combinedData.lineData != nil || combinedData.barData != nil || combinedData.candleData != nil {
            
            chartView.data = combinedData

            //add render
            (chartView.renderer as? CombinedChartRenderer)?.subRenderers.forEach{
                if $0 is CandleStickChartRenderer {
                    object_setClass($0, KLCandleStickChartRenderer.self)
                }
            }

//            chartView.setVisibleXRange(minXRange: Double(visibleXMaxCount), maxXRange: Double(visibleXMaxCount))
//            chartView.setVisibleXRangeMaximum(Double(visibleXMaxCount))

            //经验值
            chartView.setScaleMinima(CGFloat(data.count)/200.0, scaleY: 1)

            chartView.viewPortHandler.setMaximumScaleX(20)

            if //data.count < Int(visibleXMaxCount),
               let max = chartView.data?.dataSets.first?.xMax,
               let min = chartView.data?.dataSets.first?.xMin,
               max > min, min.isFinite,
               min != Double.greatestFiniteMagnitude,
               visibleXMaxCount != 0 {

                let n = (max - min)/Double(data.count)
                if data.count < Int(visibleXMaxCount) {
                    chartView.xAxis.axisMaximum = n * (Double(visibleXMaxCount) + 8) + min
                } else {
                    chartView.xAxis.axisMaximum = n * (Double(data.count) + 8) + min
                }
            }

            if data.count >= visibleXMaxCount && visibleXMaxCount > 0 {
//                chartView.setVisibleXRange(minXRange: 1, maxXRange: 1)
//                chartView.moveViewToX(chartView.chartXMax)
//                chartView.viewPortHandler.refresh(newMatrix: .identity, chart: chartView, invalidate: false)
                chartView.setVisibleXRange(minXRange: 10, maxXRange: Double(visibleXMaxCount))
            }

        }

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

    var visibleXMaxCount: Int { return delegate?.visibleXMaxCount ?? 0 }

}
