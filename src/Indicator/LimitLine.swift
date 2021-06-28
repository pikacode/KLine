//
//  LimitLine.swift
//  KLine
//
//  Created by pikacode on 2021/6/18.
//

import UIKit

///水平线 | 垂直线
public struct LimitLine {

    public init() {
        self.init(0, .horizontal)
    }

    public static var style: KLStyle = KLStyle.default

    public var value: Double {
        didSet {
            limitLine.limit = value
        }
    }

    public var direction: KLDirection

    public init(_ value: Double, _ direction: KLDirection) {
        self.value = value
        self.direction = direction
    }

    public lazy var limitLine: KLChartLimitLine = {
        let line = KLChartLimitLine(limit: Double(value), label: style.label.text)
        line.labelPosition = .topLeft
        line.yOffset = -6
        line.lineWidth = style.lineWidth1
        line.lineColor = style.lineColor1
        line.lineDashLengths = style.label.dashLengths
        line.lineDashPhase = style.label.dashPhase
        line.valueFont = style.label.font
        line.valueTextColor = style.label.color
        line.bgColor = style.label.bgColor
        return line
    }()

}

extension LimitLine: KLIndicator {}
