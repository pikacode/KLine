//
//  LimitLine.swift
//  KLine
//
//  Created by pikacode on 2021/6/18.
//

import UIKit

///水平线 | 垂直线
public class LimitLine {

    required public convenience init() {
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
        self.style.label.color = UIColor.black
    }

    public var labelText: String {
        set {
            label.text = newValue
            limitLine.label = newValue
        }
        get {
            label.text
        }
    }
    
    public var label = KLLabel(style.label)

    lazy var _limitLine: KLChartLimitLine = {
        let line = KLChartLimitLine(limit: Double(value), label: label.text)
        line.labelPosition = .topLeft
        line.yOffset = -6
        return line
    }()

    public var limitLine: KLChartLimitLine {
        get {
            let line = _limitLine
            line.label = label.text
            line.limit = value
            line.xOffset = style.xOffset
            line.lineWidth = style.lineWidth1
            line.lineColor = style.lineColor1
            line.lineDashLengths = label.dashLengths
            line.lineDashPhase = label.dashPhase
            line.valueFont = label.font
            line.valueTextColor = label.color
            line.bgColor = label.bgColor
            return _limitLine
        }
        set {
            _limitLine = newValue
        }
    }

    public var isCrosshair: Bool {
        return limitLine is KLCrosshairLimitLine
    }

}

extension LimitLine: KLIndicator {}
