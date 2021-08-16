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
        xAxis.gridColor = KLStyle.default.darkGrayColor.alpha(0.3)
        xAxis.labelTextColor = KLStyle.default.label.color
        xAxis.labelFont = KLStyle.default.label.font
        xAxis.labelHeight = 20
        xAxis.axisLineColor = KLStyle.default.darkGrayColor

        leftAxis.drawLabelsEnabled = false
        leftAxis.gridColor = KLStyle.default.darkGrayColor.alpha(0.3)
        leftAxis.axisLineColor = UIColor.clear
        
        rightAxis.labelPosition = .insideChart
        rightAxis.gridColor = KLStyle.default.darkGrayColor.alpha(0.3)
        rightAxis.labelTextColor = KLStyle.default.label.color
        rightAxis.labelFont = KLStyle.default.label.font
        rightAxis.axisLineColor = UIColor.clear

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
            klView.highlightedChanged(nil, nil)
            return
        }

        let data = views.compactMap{ (view)->(ChartData?) in
            if view.combinedData?.candleData != nil {
                return view.combinedData?.candleData
            } else {
                return view.combinedData?.lineData
            }
        }

        guard let candleData = data.first,
              let entry = candleData.dataSets.first?.entryForXValue(Double(p.x), closestToY: .nan)
        else {
            return
        }
        
        if let index = candleData.dataSets.first?.entryIndex(entry: entry) {
            KLLegendRenderer.index = index
            let pt = self.pixelForValues(x: p.x.double, y: p.y.double, axis: .left)
            klView.highlightedChanged(index, pt)
            self.refreshCustomLegend(index: index, klineView: klView)
        }

        views.forEach{
            //让 x 一格一格的改变，y可以随意改变
            $0.crosshair.point = CGPoint(x: CGFloat(entry.x), y: p.y)
            $0.crosshair.showHorizontal = $0 == self

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
    
    func refreshCustomLegend(index: Int, klineView: KLineView) {
        
        guard let lineData = klineView.data[index] as? KLineData else {
            return
        }
        let precision = KLineView.precision
        
        for section in klineView.sections {
            for item in section.indicators {
                switch item {
                case is MA:
                    guard let ma = lineData.ma else {
                        return
                    }
                    var labels = [String]()
                    for data in ma.data {
                        labels.append(String(format:  " MA\( data.key):%.\(precision)f", Double(data.value ?? 0)))
                    }
                    setCustomLegend(labels, section, [item.style.lineColor1, item.style.lineColor2, item.style.lineColor3])
                    
                case  is EMA:
                    guard let ema = lineData.ema else {
                        return
                    }
                    var labels = [String]()
                    for  type in EMA.emaDays{
                        switch type {
                        case .short(let day):
                            labels.append(String(format: "EMA(\(day)):%.\(precision)f ",ema.short_ema))
                        case .mid(let day):
                            labels.append(String(format: "EMA(\(day)):%.\(precision)f ",ema.mid_ema))
                        case .long(let day):
                            labels.append(String(format: "EMA(\(day)):%.\(precision)f ",ema.long_ema))
                        }
                    }
                    setCustomLegend(labels, section, [item.style.lineColor1, item.style.lineColor2, item.style.lineColor3])
                case is BOLL:
                    guard let boll = lineData.boll else {
                        return
                    }
                    var labels = [String]()
                    for  type in BOLL.boll_type{
                        switch type {
                        case .up:
                            labels.append(String(format: "BOLL(\(BOLL.boll_day),\(BOLL.boll_average)) UP:%.\(precision)f ", boll.up_boll))
                        case .mb:
                            labels.append(String(format: " MB:%.\(precision)f ",boll.mb_boll))
                        case .down:
                            labels.append(String(format: " DN:%.\(precision)f ",boll.dn_boll))
                        }
                    }
                    setCustomLegend(labels, section, [item.style.lineColor1, item.style.lineColor2, item.style.lineColor3])
                    
                case is MACD:
                    guard let macd = lineData.macd else {
                        return
                    }

                    var labels = [String]()
                    for  type in MACD.macd_type{
                        switch type {
                        case .macd:
                            labels.append(String(format: " MACD:%.\(precision)f ", macd.macd))
                        case .dea:
                            labels.append(String(format: "MACD(\(MACD.short_period),\(MACD.short_period),\(MACD.short_period)) DEA:%.\(precision)f ", macd.dea))
                        case .dif:
                            labels.append(String(format: " DIF:%.\(precision)f ", macd.dif))
                        }
                    }
                    setCustomLegend(labels, section, [item.style.lineColor1, item.style.lineColor2, item.style.lineColor3])
                    
                case is MAVOL:
                    guard let mavol = lineData.mavol else {
                        return
                    }
                    var labels = [String]()
                    let volPrecision = KLineView.volPrecision
                    
                    for (index, data) in mavol.data.enumerated() {
                        if index == 0 {
                            labels.append(String(format:  "VOL:%.\(volPrecision)f  MAVOL\( data.key):%.\(volPrecision)f", lineData.vol, Double(data.value ?? 0)))
                        }else{
                            labels.append(String(format:  " MAVOL\( data.key):%.\(volPrecision)f", Double(data.value ?? 0)))
                        }
                    }
                    setCustomLegend(labels, section, [item.style.lineColor1, item.style.lineColor2, item.style.lineColor3])
                case is KDJ:
                    guard let kdj = lineData.kdj else {
                        return
                    }
                    var labels = [String]()
                    for  type in KDJ.macd_type{
                        switch type {
                        case .K:
                            labels.append(String(format: "KDJ(\(KDJ.calculate_period),\(KDJ.ma1_period),\(KDJ.ma2_period)) K:%.\(precision)f ", kdj.k))
                        case .D:
                            labels.append(String(format: " D:%.\(precision)f ",kdj.k))
                        case .J:
                            labels.append(String(format: " J:%.\(precision)f ",kdj.j))
                        }
                    }
                    setCustomLegend(labels, section, [item.style.lineColor1, item.style.lineColor2, item.style.lineColor3])
                case is RSI:
                    guard let rsi = lineData.rsi else {
                        return
                    }
                    var labels = [String]()
                    for  type in RSI.rsiDays{
                        switch type {
                        case .RSI1(let day):
                            labels.append(String(format: "RSI(\(day)):%.\(precision)f ",rsi.rsi6))
                        case .RSI2(let day):
                            labels.append(String(format: "RSI(\(day)):%.\(precision)f ",rsi.rsi12))
                        case .RSI3(let day):
                            labels.append(String(format: "RSI(\(day)):%.\(precision)f ",rsi.rsi24))
                        }
                    }
                    setCustomLegend(labels, section, [item.style.lineColor1, item.style.lineColor2, item.style.lineColor3])
                default: break
                }
            }
        }
    }
    
    func setCustomLegend(_ labels: [String], _ section: KLSection, _ color: [UIColor]){
        
        var entries: [LegendEntry] = []
        
        for (index, label) in labels.enumerated() {
            let lem = LegendEntry.init(label: label, form: .none, formSize: 0, formLineWidth: legend.formLineWidth, formLineDashPhase: 0, formLineDashLengths: nil, formColor: color[index~])
            entries.append(lem)
        }
        if entries.count == 0 {
            section.chartView.legend.resetCustom()
            return
        }
        section.chartView.legend.setCustom(entries: entries)
    }
}

extension BarLineChartViewBase {

    @objc func panGestureRecognized_1(_ recognizer: NSUIPanGestureRecognizer) {
        panGestureRecognized_1(recognizer)
    }

}
