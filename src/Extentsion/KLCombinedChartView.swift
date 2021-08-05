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
                if let ges = UIViewController.current?.navigationController?.interactivePopGestureRecognizer {
                    pan.require(toFail: ges)
                }
            }
            $0.delaysTouchesBegan = true
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

    open override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let context = UIGraphicsGetCurrentContext() else { return }

        //rang
        if leftAxis.isEnabled && !leftAxis.isDrawLimitLinesBehindDataEnabled {
            leftYAxisRenderer.renderLimitLines(context: context)
        }

        if rightAxis.isEnabled && !rightAxis.isDrawLimitLinesBehindDataEnabled {
            rightYAxisRenderer.renderLimitLines(context: context)
        }

        renderKLMarker(context: context)
    }

    func renderKLMarker(context: CGContext) {

        guard let marker = klMarker else { return }

        guard let point = crosshair.point else {
            return
        }

        let pt = self.pixelForValues(x: point.x.double, y: point.y.double, axis: .left)
        marker.draw(context: context, point: pt)
    }

    open func changeCrosshair(_ point: CGPoint?, force: Bool = false) {

        guard let klView = superview as? KLineView else { return }

        guard point != crosshair.point || force else { return }

        let views = klView.subviews.compactMap{ $0 as? KLCombinedChartView }

        views.forEach{
            //移除
            [$0.leftAxis, $0.rightAxis, $0.xAxis].forEach { (axis) in
                axis.limitLines.filter { (l) -> Bool in
                    return l.isCrosshair
                }.forEach { (l) in
                    axis.removeLimitLine(l)
                }
            }
            $0.setNeedsDisplay()
        }

        guard let p = point else {
            klView.highlightedChanged(nil)
            return
        }

        guard let candleData = views.compactMap({ $0.combinedData?.candleData }).first,
              let entry = candleData.dataSets.first?.entryForXValue(Double(p.x), closestToY: .nan) as? CandleChartDataEntry
        else {
            return
        }

        if let index = candleData.dataSets.first?.entryIndex(entry: entry) {
            klView.highlightedChanged(index)
        }

        views.forEach{

            //让 x 一格一格的改变，y可以随意改变
            $0.crosshair.point = CGPoint(x: CGFloat(entry.x), y: p.y)

            //当前画横轴
            if $0 == self {
                if let h = $0.crosshair.horizontal {
                    $0.leftAxis.addLimitLine(h.limitLine)
                    $0.rightAxis.addLimitLine(h.limitLine)
                }
            }
            if let v = $0.crosshair.vertical {
                $0.xAxis.addLimitLine(v.limitLine)
            }

            $0.setNeedsDisplay()
        }

    }

}

extension BarLineChartViewBase {

    @objc func panGestureRecognized_1(_ recognizer: NSUIPanGestureRecognizer) {
        panGestureRecognized_1(recognizer)
    }

}
