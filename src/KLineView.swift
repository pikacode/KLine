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

    public init(_ sections: [KLSection]) {
        self.sections = sections
        super.init(frame: .zero)
    }

    public var sections: [KLSection] {
        willSet {
            newValue.forEach{ $0.offset = sections[0].offset }
        }
        didSet {
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
                view.backgroundColor = UIColor(red: CGFloat.random(in: 0...255)/255, green: CGFloat.random(in: 0...255)/255, blue: CGFloat.random(in: 0...255)/255, alpha: 0.3)
                let height = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: $0.height)
                let left = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
                let right = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
                self.addConstraints([left, right, top, height])
            }
        }
    }

    public var needHeight: CGFloat {
        return sections.reduce(0, { $0 + $1.height })
    }

    public func setData(_ data: [KLineData], completion: @escaping ()->() = {}) {
        setDataCompletion = completion
        self.data = data
    }

    public func setCustomData(_ data: [Any], completion: @escaping ()->() = {}) {
        setDataCompletion = completion
        self.data = data
    }

    public var data: [Any] {
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
                        if var d = newData as? [KLineData] {
                            $0.calculate(&d)
                        } else {
                            $0.calculate(custom: &newData)
                        }
                    }
                    self.realData = newData
                    self.isCalculating = false
                    if self.dataDidSetWhenCalculate {
                        self.dataDidSetWhenCalculate = false
                        self.data = self.tempData
                    } else {
                        DispatchQueue.main.async {
                            self.sections.forEach{ $0.draw(self.data) }
                            self.setDataCompletion()
                        }
                    }
                }
            }
        }
    }

    // MARK: - private

    var setDataCompletion = {}

    let queue = DispatchQueue(label: "KLine")

    var indicators: [KLIndicator.Type] { return sections.flatMap{ $0.indicators } }

    var isCalculating = false
    var dataDidSetWhenCalculate = false

    var tempData = [Any]()
    var realData = [Any]()

    open override func layoutSubviews() {
        if subviews.count != sections.count {
            let s = sections
            sections = s
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

}
