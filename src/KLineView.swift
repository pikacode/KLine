//
//  KLineView.swift
//  Kline
//
//  Created by pikacode on 2021/6/1.
//

import UIKit
import Charts

open class KLineView: UIView {

    public var sections: [KLSection] = [KLSection()] {
        didSet {

        }
    }

    let queue = DispatchQueue(label: "KLine")

    var types: [KLineType] { return sections.flatMap{ $0.types } }

    private var isCalculating = false {
        didSet {
            if !isCalculating && data.count != tempData.count && data.first?.time != tempData.first?.time {
                data = tempData
                setDataCompletion()
            }
        }
    }

    private var tempData = [KLineData]()
    private var realData = [KLineData]()

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

    private var setDataCompletion = {}

    public func setData(_ data: [KLineData], completion: @escaping ()->() = {}) {
        setDataCompletion = completion
        self.data = data
    }

    public let chartView = KLCombinedChartView(frame: .zero)

    public init(sections: [KLSection]) {
        self.sections = sections
        super.init(frame: .zero)
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(chartView)
        [NSLayoutConstraint.Attribute.top, .bottom, .left, .right].forEach{
            let c = NSLayoutConstraint(item: self, attribute: $0, relatedBy: .equal, toItem: chartView, attribute: $0, multiplier: 1, constant: 0)
            self.addConstraint(c)
        }
    }

    public func reload() {

    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    

}
