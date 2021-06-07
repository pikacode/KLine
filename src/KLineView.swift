//
//  KLineView.swift
//  Kline
//
//  Created by pikacode on 2021/6/1.
//

import UIKit
import Charts

open class KLineView: UIView {

    public var types: [[KLineType]] {
        didSet {

        }
    }

    var data = [KLineData]() {
        didSet {
            types.flatMap{ $0 }.forEach{
                calculate($0)
            }
        }
    }

    lazy var MACD = [Any]()

    func calculate(_ type: KLineType) {
//        MACD = ...
    }

    func getMACD() -> [Any] {
        return [Any]()
    }

    public let chartView = KLCombinedChartView(frame: .zero)

    public init(types: [[KLineType]]) {
        self.types = types
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
