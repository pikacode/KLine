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

    public init(sections: [KLSection]) {
        self.sections = sections
        super.init(frame: .zero)
    }

    public var sections: [KLSection] = [KLSection()] {
        didSet {

        }
    }

    public func setData(_ data: [KLineData], completion: @escaping ()->() = {}) {
        setDataCompletion = completion
        self.data = data
    }

    public var data: [KLineData] {
        set {
            tempData = data
            if isCalculating {
                return
            } else {
                var newData = newValue
                isCalculating = true
                queue.async {
                    self.types.forEach{ $0.calculate(&newData) }
                    self.realData = newData
                    self.isCalculating = false
                    // realData != tempData 说明计算过程中又修改了数据
                    if self.realData.count != self.tempData.count &&
                        self.realData.first != self.tempData.first {
                        self.data = self.tempData
                    } else {
                        DispatchQueue.main.async {
                            self.setDataCompletion()
                        }
                    }
                }
            }
        }
        get {
            return realData
        }
    }

    public let chartView = KLCombinedChartView(frame: .zero)

    // MARK: - private

    var setDataCompletion = {}

    let queue = DispatchQueue(label: "KLine")

    var types: [KLineType] { return sections.flatMap{ $0.types } }

    var isCalculating = false

    var tempData = [KLineData]()
    var realData = [KLineData]()

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(chartView)
        [NSLayoutConstraint.Attribute.top, .bottom, .left, .right].forEach{
            let c = NSLayoutConstraint(item: self, attribute: $0, relatedBy: .equal, toItem: chartView, attribute: $0, multiplier: 1, constant: 0)
            self.addConstraint(c)
        }
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
