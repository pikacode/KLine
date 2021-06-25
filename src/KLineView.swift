//
//  KLineView.swift
//  Kline
//
//  Created by pikacode on 2021/6/1.
//

import UIKit
import Charts

open class KLineView: UIView {

    // MARK: - public

    /// true: 自动移到图表最后
    open var autoMoveToXMaxAfterSetData = true

    public init(_ sections: [KLSection]) {
        self.sections = sections
        super.init(frame: .zero)
    }

    open var sections: [KLSection] {
        willSet {
            newValue.forEach{ $0.offset = sections[0].offset }
        }
        didSet {
            queue.async {
                self.indicators.forEach{ type(of: $0).calculate(&self.data) }
                DispatchQueue.main.async {
                    self.draw()
                }
            }
        }
    }

    open var neededHeight: CGFloat {
        return sections.reduce(0, { $0 + $1.height })
    }

    open func setData(_ data: [KLineData], completion: @escaping ()->() = {}) {
        setDataCompletion = completion
        self.data = data
    }

    open func setCustomData(_ data: [Any], completion: @escaping ()->() = {}) {
        setDataCompletion = completion
        self.data = data
    }

    open func draw() {
        layout()
        sections.forEach{ $0.draw() }
    }

    /// 一个经验值，控制 label 的密度，数字越大数量越多
    /// 可以通过修改 chartView.rightAxis.labelCount 自行控制具体数量
    open var labelGranularity: CGFloat = 1

    /// [KLineData] or custom [Any]
    open var data: [Any] {
        get {
            return realData
        }
        set {
            tempData = newValue
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
                            self.sections.forEach{
                                $0.data = self.data
                            }
                            self.setDataCompletion()
                            if self.autoMoveToXMaxAfterSetData && self.data.count > 52 {
                                self.moveToXMax()
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - private

    var setDataCompletion = {}

    let queue = DispatchQueue(label: "KLine")

    var indicators: [KLIndicator] { return sections.flatMap{ $0.indicators } }

    var isCalculating = false
    var dataDidSetWhenCalculate = false

    var tempData = [Any]()
    var realData = [Any]()

    func moveToXMax() {
        sections.forEach{
            $0.chartView.moveViewToX($0.chartView.chartXMax)
        }
    }

    func moveToXMin() {
        sections.forEach{
            $0.chartView.moveViewToX(0)
        }
    }

    func layout() {
        let transform = sections.first?.chartView.viewPortHandler.touchMatrix
        let scale = sections.first?.chartView.viewPortHandler.scaleX ?? 1.5
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
//            view.backgroundColor = UIColor(red: CGFloat.random(in: 0...255)/255, green: CGFloat.random(in: 0...255)/255, blue: CGFloat.random(in: 0...255)/255, alpha: 0.3)
            let height = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: $0.height)
            let left = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
            let right = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
            self.addConstraints([left, right, top, height])
            if let transform = transform {
                view.viewPortHandler.setZoom(scaleX: scale, scaleY: 1)
                view.viewPortHandler.refresh(newMatrix: transform, chart: view, invalidate: true)
            }
            view.rightAxis.labelCount = Int($0.height * $0.height / 12000 * self.labelGranularity)
        }
    }


//    open override func didMoveToSuperview() {
//        super.didMoveToSuperview()
//        chartView.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(chartView)
//        [NSLayoutConstraint.Attribute.top, .bottom, .left, .right].forEach{
//            let c = NSLayoutConstraint(item: self, attribute: $0, relatedBy: .equal, toItem: chartView, attribute: $0, multiplier: 1, constant: 0)
//            self.addConstraint(c)
//        }
//    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}

extension KLineView: ChartViewDelegate {

    public func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        let views = sections.map{ $0.chartView }.filter{ $0 != chartView }
        let p = CGPoint(x: dX, y: dY)
        views.forEach{
            let originalMatrix = $0.viewPortHandler.touchMatrix
            var matrix = CGAffineTransform(translationX: p.x, y: p.y)
            matrix = originalMatrix.concatenating(matrix)
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
