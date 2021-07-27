//
//  KLCombinedChartView.swift
//  KLine
//
//  Created by pikacode on 2021/6/2.
//

import UIKit
import Charts

open class KLCombinedChartView: CombinedChartView {

    open var showCrosshair = true {
        didSet{
            if !showCrosshair {
                changeCrosshair(nil)
                setNeedsDisplay()
            }
        }
    }

    var crosshairChanged = { (_: CGPoint?) in }
    var highlightIndex = { (index: Int) in}

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

    open var klMarker: KLMarker?
        
    open func initUI() {

        backgroundColor = KLStyle.default.backgroundColor

        drawGridBackgroundEnabled = true

        noDataText = ""

        gridBackgroundColor = KLStyle.default.backgroundColor

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
        xAxis.labelHeight = 20

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
        highlightPerTapEnabled = false

        object_setClass(xAxisRenderer.transformer, KLTransformer.self)

        addGestureRecognizer(longPressGesture)
        addGestureRecognizer(tapPressGesture)
        gestureRecognizers?.forEach{
            if let pan = $0 as? UIPanGestureRecognizer {
                pan.require(toFail: self.longPressGesture)
            }
        }
    }

    /// for Crosshair

    public let crosshair = Crosshair()

    public lazy var longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureSelector(_:)))
    public lazy var tapPressGesture = UITapGestureRecognizer(target: self, action: #selector(tapPressGestureSelector(_:)))

    @objc func tapPressGestureSelector(_ ges: UILongPressGestureRecognizer) {
        guard showCrosshair else {
            return
        }
        let translation = ges.location(in: self)
        let point = valueForTouchPoint(point: translation, axis: .left)
        changeCrosshair(point)
    }

    @objc func longPressGestureSelector(_ ges: UILongPressGestureRecognizer) {
        guard showCrosshair else {
            return
        }
        let translation = ges.location(in: self)
        let point = valueForTouchPoint(point: translation, axis: .left)
        changeCrosshair(point)
    }

    override func panGestureRecognized_1(_ recognizer: NSUIPanGestureRecognizer) {
        super.panGestureRecognized_1(recognizer)
        changeCrosshair(nil)
    }

}


/// Crosshair
extension KLCombinedChartView {

    open func changeCrosshair(_ point: CGPoint?, drawHorizontal: Bool = true) {

        if point == crosshair.point {
            return
        }

        [leftAxis, rightAxis, xAxis].forEach { (axis) in
            axis.limitLines.filter { (l) -> Bool in
                return l.isCrosshair
            }.forEach { (l) in
                axis.removeLimitLine(l)
            }
        }

        crosshair.point = point

        if drawHorizontal {
            crosshairChanged(crosshair.point)
        }

        if drawHorizontal {
            if let h = crosshair.horizontal {
                leftAxis.addLimitLine(h.limitLine)
                rightAxis.addLimitLine(h.limitLine)
            }
        }

        if let v = crosshair.vertical {
            xAxis.addLimitLine(v.limitLine)
        }

        setNeedsDisplay()
    }

    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        if klMarker == nil { return }
        let optionalContext = UIGraphicsGetCurrentContext()
        guard let context = optionalContext else { return }

        guard let point = crosshair.point else {
            return
        }
        let x = point.x
        let y = point.y
        
        let pt = self.pixelForValues(x: Double(x), y: Double(y), axis: .left)
        if let entry = self.combinedData?.candleData?.dataSets.first?.entryForXValue(Double(x), closestToY: .nan) as? CandleChartDataEntry {
            guard let index = self.combinedData?.candleData?.dataSets.first?.entryIndex(entry: entry) else { return }
            highlightIndex(index)
            klMarker?.draw(context: context, point: pt)
        }

        //rang
        if leftAxis.isEnabled && !leftAxis.isDrawLimitLinesBehindDataEnabled
        {
            leftYAxisRenderer.renderLimitLines(context: context)
        }

        if rightAxis.isEnabled && !rightAxis.isDrawLimitLinesBehindDataEnabled
        {
            rightYAxisRenderer.renderLimitLines(context: context)
        }
    }
}

extension BarLineChartViewBase {

    //十字光标
//    private static var showCrosshairKey = 0
//    var showCrosshair: Bool {
//        set {
//            objc_setAssociatedObject(self, &BarLineChartViewBase.showCrosshairKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
//        }
//        get {
//            objc_getAssociatedObject(self, &BarLineChartViewBase.showCrosshairKey) as? Bool ?? true
//        }
//    }

    @objc func panGestureRecognized_1(_ recognizer: NSUIPanGestureRecognizer) {
        panGestureRecognized_1(recognizer)
    }

}
