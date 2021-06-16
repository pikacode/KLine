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
                view.translatesAutoresizingMaskIntoConstraints = false
                let top: NSLayoutConstraint
                if let last = self.subviews.last {
                    top = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: last, attribute: .bottom, multiplier: 1, constant: 0)
                } else {
                    top = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
                }
                self.addSubview(view)
                view.backgroundColor = UIColor(red: CGFloat.random(in: 0...255)/255, green: CGFloat.random(in: 0...255)/255, blue: CGFloat.random(in: 0...255)/255, alpha: CGFloat.random(in: 0.3...0.8))
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

    public var data: [KLineData] {
        get {
            return realData
        }
        set {
            tempData = newValue
            if isCalculating {
                return
            } else {
                var newData = newValue
                isCalculating = true
                queue.async {
                    self.indicators.forEach{ $0.calculate(&newData) }
                    self.realData = newData
                    self.isCalculating = false
                    // realData != tempData 说明计算过程中又修改了数据
                    if self.realData.count != self.tempData.count &&
                        self.realData.first != self.tempData.first {
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

    var tempData = [KLineData]()
    var realData = [KLineData]()

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
