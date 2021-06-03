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
        super.init(frame: frame)
        KLCombinedChartView.exchangeMethod()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        KLCombinedChartView.exchangeMethod()
        initUI()
    }

    func initUI() {
        drawGridBackgroundEnabled = true
        gridBackgroundColor = 0x0e0e0e.toColor

        xAxis.labelPosition = .bottomInside
        xAxis.gridColor = 0x262626.toColor
        xAxis.labelTextColor = UIColor.white.alpha(0.6)
        xAxis.labelFont = UIFont.systemFont(ofSize: 9)

        leftAxis.drawLabelsEnabled = false
        leftAxis.gridColor = 0x262626.toColor

        rightAxis.labelPosition = .insideChart
        rightAxis.gridColor = 0x262626.toColor
        rightAxis.labelTextColor = UIColor.white.alpha(0.6)
        rightAxis.labelFont = UIFont.systemFont(ofSize: 9)

        scaleXEnabled = true
        scaleYEnabled = false
        dragXEnabled = true
        dragYEnabled = false
        doubleTapToZoomEnabled = false

        xAxis.axisMaximum = 30
        viewPortHandler.setMaximumScaleX(10)
        zoomToCenter(scaleX: 3, scaleY: 1)
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

        if showCrosshair {
            let point = recognizer.location(in: self)
            let point1 = (self.highlighter as? ChartHighlighter)?.getValsForTouch(x: point.x, y: point.y)
            crossPoint = point1
        }
    }

    let crossLabel = "KLCross"

    var crossPoint: CGPoint? {
        didSet {
//            data = CombinedChartData()
            print(crossPoint)
            guard let chartData = data as? CombinedChartData else { return }

            let crossSet: LineChartDataSet = {
                guard let p = crossPoint else { return LineChartDataSet() }
                let entries = [ChartDataEntry(x: Double(p.x), y: Double(p.y))]
                let set = LineChartDataSet(entries: entries, label: crossLabel)
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

            if let index = chartData.lineData.dataSets.firstIndex(where: { $0.label == crossLabel }) {
                chartData.lineData.dataSets[index] = crossSet
            } else {
                chartData.lineData.addDataSet(crossSet)
            }
            data = chartData
            setNeedsDisplay()
        }
    }

    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let p = crossPoint,
              let context = UIGraphicsGetCurrentContext(),
              let index = (data as? CombinedChartData)?.lineData.dataSets.firstIndex(where: { $0.label == crossLabel })
        else { return }
        let h = Highlight(x: Double(p.x), y: Double(p.y), dataSetIndex: index)
        renderer?.drawHighlighted(context: context, indices: [h])
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
