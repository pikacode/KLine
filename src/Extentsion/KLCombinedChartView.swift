//
//  KLCombinedChartView.swift
//  KLine
//
//  Created by pikacode on 2021/6/2.
//

import UIKit
import Charts

open class KLCombinedChartView: CombinedChartView {

    private static var didExchangeMethod = false
    public class func exchangeMethod(){

        if didExchangeMethod { return }
        didExchangeMethod = true
        let s1 = Selector("panGestureRecognized:")
        let s2 = #selector(KLCombinedChartView.panGestureRecognized_1(_:))
        guard let m1 = class_getInstanceMethod(BarLineChartViewBase.self, s1),
              let m2 = class_getInstanceMethod(BarLineChartViewBase.self, s2) else { return }
        method_exchangeImplementations(m1, m2)
    }

    public override init(frame: CGRect) {
        KLCombinedChartView.exchangeMethod()
        super.init(frame: frame)
        initUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        KLCombinedChartView.exchangeMethod()
        super.init(coder: aDecoder)
        initUI()
    }

    open func initUI() {

        drawGridBackgroundEnabled = true
        gridBackgroundColor = 0x0e0e0e.toColor

        autoScaleMinMaxEnabled = true

        minOffset = 0

        object_setClass(legendRenderer, KLLegendRenderer.self)
        legend.form = .none
        legend.verticalAlignment = .top
        legend.drawInside = true
        legend.font = UIFont.systemFont(ofSize: 9)
        legend.formSize = 0
        legend.xEntrySpace = 10
        legend.formToTextSpace = 0
        legend.xOffset = 10
        legend.yOffset = 2

        xAxis.labelPosition = .bottomInside
        xAxis.gridColor = KLStyle.default.darkGrayColor
        xAxis.labelTextColor = KLStyle.default.label.color
        xAxis.labelFont = KLStyle.default.label.font

        leftAxis.drawLabelsEnabled = false
        leftAxis.gridColor = KLStyle.default.darkGrayColor

        rightAxis.labelPosition = .insideChart
        rightAxis.gridColor = KLStyle.default.darkGrayColor
        rightAxis.labelTextColor = UIColor.white.alpha(0.6)
        rightAxis.labelFont = KLStyle.default.label.font

        scaleXEnabled = true
        scaleYEnabled = false
        dragXEnabled = true
        dragYEnabled = false
        doubleTapToZoomEnabled = false

//        viewPortHandler.setMaximumScaleX(10)
//        zoomToCenter(scaleX: 3, scaleY: 1)
    }

    override func panGestureRecognized_1(_ recognizer: NSUIPanGestureRecognizer) {
        super.panGestureRecognized_1(recognizer)
        if recognizer.state != NSUIGestureRecognizerState.changed { return }
//        if let ivar = class_getInstanceVariable(BarLineChartViewBase.self, "_isDragging") {
//            let isDragging = object_getIvar(self, ivar) as? Bool ?? false
//            if isDragging {
//                return
//            }
//        }

//        if showCrosshair {
//            let point = recognizer.location(in: self)
//            let point1 = (self.highlighter as? ChartHighlighter)?.getValsForTouch(x: point.x, y: point.y)
//            crossPoint = point1
//        }
    }

    var crossPoint: CGPoint? {
        didSet {
            guard let chartData = data as? CombinedChartData else { return }

            let crossSet: LineChartDataSet = {
                guard let p = crossPoint else { return LineChartDataSet() }
                let entries = [ChartDataEntry(x: Double(p.x), y: Double(p.y))]
                let set = LineChartDataSet(entries: entries, label: Crosshair.label)
                set.setColor(UIColor.blue)
                set.lineWidth = 2.5
                set.mode = .linear
                set.drawValuesEnabled = false
                set.drawCirclesEnabled = false
                set.axisDependency = .left
                set.highlightColor = 0x979797.toColor
                set.highlightLineDashPhase = 2
                set.highlightLineDashLengths = [4]
                return set
            }()

            if let index = chartData.lineData?.dataSets.firstIndex(where: { $0.label == Crosshair.label }) {
                chartData.lineData?.dataSets[index] = crossSet
            } else {
                chartData.lineData?.addDataSet(crossSet)
            }
            data = chartData
            setNeedsDisplay()
        }
    }

    open override func draw(_ rect: CGRect) {
        super.draw(rect)
//        guard let p = crossPoint,
//              let context = UIGraphicsGetCurrentContext(),
//              let index = (data as? CombinedChartData)?.lineData?.dataSets.firstIndex(where: { $0.label == Crosshair.label })
//        else { return }
//        let h = Highlight(x: Double(p.x), y: Double(p.y), dataSetIndex: index)
//        renderer?.drawHighlighted(context: context, indices: [h])
    }

}

extension BarLineChartViewBase {

    //十字光标
    private static var showCrosshairKey = 0
    var showCrosshair: Bool {
        set {
            objc_setAssociatedObject(self, &BarLineChartViewBase.showCrosshairKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            objc_getAssociatedObject(self, &BarLineChartViewBase.showCrosshairKey) as? Bool ?? true
        }
    }

    @objc func panGestureRecognized_1(_ recognizer: NSUIPanGestureRecognizer) {
        panGestureRecognized_1(recognizer)
    }

}
