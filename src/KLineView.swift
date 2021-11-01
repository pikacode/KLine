//
//  KLineView.swift
//  Kline
//
//  Created by pikacode on 2021/6/1.
//

import UIKit
import Charts

open class KLineView: UIView {

    public var highlightedChanged = { (index: Int?, point: CGPoint?) in }

    public init(_ sections: [KLSection]) {
        self.sections = sections
        super.init(frame: .zero)
    }

    /// set sections will trigger [calculate] - [layout] - [draw]
    open var sections: [KLSection] {
        willSet {
            newValue.forEach{ $0.offset = sections[0].offset }
        }
        didSet {
            let need = needMoveToXMax
            sections.forEach{ $0.delegate = self }
            queue.async {
                self.indicators.forEach{ type(of: $0).calculate(&self.realData) }
                DispatchQueue.main.async {
                    self.layout()
                    self.draw()
                    if need {
                        self.moveToXMax()
                    }
                }
            }
        }
    }

    /// [KLineData] or custom [Any]
    /// set data will trigger [calculate] - [draw]
    open var data: [Any] {
        get {
            return realData
        }
        set {
            tempData = newValue
            if let d = newValue as? [KLineData], newValue.count >= 2 {
                let t: TimeInterval
                if newValue.count >= 4 {
                    t = d[3].time - d[2].time
                } else if newValue.count >= 2 {
                    t = d[1].time - d[0].time
                } else {
                    t = 60 * 60 * 24
                }
                KLineData.timeXScale = t
            }
            if isCalculating {
                dataDidSetWhenCalculate = true
                return
            } else {
                var newData = newValue
                isCalculating = true
                queue.async {
                    self.indicators.forEach{
                        type(of: $0).calculate(&newData)
                    }
                    self.realData = newData
                    self.isCalculating = false
                    if self.dataDidSetWhenCalculate {
                        self.dataDidSetWhenCalculate = false
                        self.data = self.tempData
                    } else {
                        DispatchQueue.main.async {
                            self.draw()
                            if self.subviews.count == 0 {
                                self.layout()
                            }
                            self.setDataCompletion()
                        }
                    }
                }
            }
        }
    }

    open var neededHeight: CGFloat {
        return sections.reduce(0, { $0 + $1.height })
    }

    public func moveToXMax() {
        needMoveToXMax = true
        sections.forEach{
            $0.chartView.viewPortHandler.refresh(newMatrix: .identity, chart: $0.chartView, invalidate: false)
            if data.count == 1 {
                $0.chartView.setScaleMinima(0.05, scaleY: 1)
            } else {
                $0.chartView.setScaleMinima(CGFloat(max(data.count, visibleXMaxCount))/200.0, scaleY: 1)
            }
            $0.chartView.viewPortHandler.setMaximumScaleX(20)

            let s = $0.chartView.xAxis.axisRange/Double(visibleXMaxCount)
            let t = $0.chartView.viewPortHandler.setZoom(scaleX: CGFloat(s), scaleY: 1)
            $0.chartView.viewPortHandler.refresh(newMatrix: t, chart: $0.chartView, invalidate: false)
            $0.chartView.moveViewToX($0.chartView.chartXMax)
        }
    }

    public var scaleXEnabled: Bool = true
    public var drawGridLinesEnabled: Bool = true

    public static var precision: Int = 8
    public static var volPrecision: Int = 2

    public func clearCrosshair() {
        sections.forEach{ $0.chartView.changeCrosshair(nil) }
    }

    public func moveToXMin() {
        needMoveToXMin = true
        sections.forEach{
            $0.chartView.moveViewToX(0)
        }
    }

    /// ⭐️ should call draw before layout
    open func draw() {
        let transform = sections.first?.chartView.viewPortHandler.touchMatrix
        //let scale = sections.first?.chartView.viewPortHandler.scaleX ?? 1.5
        sections.forEach{ $0.data = self.data }

        if let transform = transform, transform.tx != 0 {
            sections.forEach{
                //$0.chartView.viewPortHandler.setZoom(scaleX: scale, scaleY: 1)
                $0.chartView.viewPortHandler.refresh(newMatrix: transform, chart: $0.chartView, invalidate: true)
            }
        }

        if needMoveToXMax && data.count > visibleXMaxCount {
            moveToXMax()
        }
        needMoveToXMax = false

        if needMoveToXMin {
            moveToXMin()
        }
        needMoveToXMin = false
    }

    open func removeLimitLines() {
        sections.forEach{ $0.removeLimitLines() }
    }

//    /// tell the view needupdate when data changed without redraw
//    open func needUpdate() {
//        indicators.forEach{ type(of: $0).calculate(&newData) }
//        sections.forEach{ $0.}
//    }

    /// 一个经验值，控制 label 的密度，数字越大数量越多
    /// 可以通过修改 chartView.rightAxis.labelCount 自行控制具体数量
    open var labelGranularity: CGFloat = 1

    open func setData(_ data: [KLineData], completion: @escaping ()->() = {}) {
        setDataCompletion = completion
        self.data = data
    }

    open func setCustomData(_ data: [Any], completion: @escaping ()->() = {}) {
        setDataCompletion = completion
        self.data = data
    }

    open var visibleXMaxCount: Int = 52

    // MARK: - private

    var setDataCompletion = {}

    var needMoveToXMax = false

    var needMoveToXMin = false

//    let queue = DispatchQueue(label: "KLine")
    let queue = DispatchQueue.main

    var indicators: [KLIndicator] { return sections.flatMap{ $0.indicators } }

    var isCalculating = false
    var dataDidSetWhenCalculate = false

    open var tempData = [Any]()
    var realData = [Any]()

    open func layout() {
//        let transform = sections.first?.chartView.viewPortHandler.touchMatrix
//        let scale = sections.first?.chartView.viewPortHandler.scaleX ?? 1.5

        subviews.forEach{ $0.removeFromSuperview() }
        sections.forEach{
            let view = $0.chartView
            view.delegate = self
            view.translatesAutoresizingMaskIntoConstraints = false
            let top: NSLayoutConstraint
            if let last = self.subviews.last {
                top = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: last, attribute: .bottom, multiplier: 1, constant: 0)
            } else {
                top = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
            }
            self.addSubview(view)
            let height = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: $0.height)
            let left = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
            let right = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
            self.addConstraints([left, right, top, height])
//            if let transform = transform, transform.tx != 0 {
//                view.viewPortHandler.setZoom(scaleX: scale, scaleY: 1)
//                view.viewPortHandler.refresh(newMatrix: transform, chart: view, invalidate: true)
//            }
            if needMoveToXMax {
                view.moveViewToX(view.chartXMax)
            }
            if needMoveToXMin {
                view.moveViewToX(0)
            }
            view.rightAxis.labelCount = Int($0.height * $0.height / 12000 * self.labelGranularity)

            view.scaleXEnabled = self.scaleXEnabled
        }

        sections.enumerated().forEach{
            if $0.offset == 0 {
                $0.element.xAxis.drawGridLinesEnabled = self.drawGridLinesEnabled
                $0.element.leftAxis.drawGridLinesEnabled = self.drawGridLinesEnabled
                $0.element.rightAxis.drawGridLinesEnabled = self.drawGridLinesEnabled
            } else {
                $0.element.xAxis.drawGridLinesEnabled = self.drawGridLinesEnabled
                $0.element.leftAxis.drawGridLinesEnabled = false
                $0.element.rightAxis.drawGridLinesEnabled = false
            }
        }

        layoutIfNeeded()

        needMoveToXMax = false
        needMoveToXMin = false
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension KLineView: ChartViewDelegate {

    public func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        let views = sections.map{ $0.chartView }.filter{ $0 != chartView }
        let p = CGPoint(x: dX, y: dY)
        let touchMatrix = chartView.viewPortHandler.touchMatrix
        var matrix = CGAffineTransform(translationX: p.x, y: p.y)
        matrix = touchMatrix.concatenating(matrix)
        views.forEach{
            $0.viewPortHandler.refresh(newMatrix: matrix, chart: $0, invalidate: true)
        }
    }

    public func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        let views = sections.map{ $0.chartView }.filter{ $0 != chartView }
        let t = chartView.viewPortHandler.touchMatrix
        views.forEach{
            if abs($0.chartXMax) != .greatestFiniteMagnitude {
                _ = $0.viewPortHandler.zoom(scaleX: scaleX, scaleY: scaleY)
            }
            $0.viewPortHandler.refresh(newMatrix: t, chart: $0, invalidate: true)
        }
    }

}
