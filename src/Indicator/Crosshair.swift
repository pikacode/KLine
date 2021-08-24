//
//  Crosshair.swift
//  KLine
//
//  Created by pikacode on 2021/6/2.
//

import UIKit
import Charts

open class Crosshair {
    required public init() {}

    public var showHorizontal = true

    public static var dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = " MM-dd HH:mm "
        return f
    }()

    var point: CGPoint? {
        didSet {
            if let x = point?.x {
                _vertical.value = Double(x)
                let date = Date(timeIntervalSince1970: Double(x) * KLineData.timeXScale)
                _vertical.label.text = Crosshair.dateFormatter.string(from: date)
            }
            if let y = point?.y {
                _horizontal.value = Double(y)
                _horizontal.label.text = " " + y.decimal.toString(precision: KLineView.precision) + " "
            }
        }
    }

    /// set to nil if u want to hide
    var _horizontal: LimitLine = {
        let l = LimitLine(0, .horizontal)
        object_setClass(l.limitLine, KLCrosshairLimitLine.self)
        l.label.bgColor = 0x0188ff.toColor
        l.label.color = UIColor.white
        l.label.font = UIFont.boldSystemFont(ofSize: 9)
        l.limitLine.labelPosition = .topRight
        l.limitLine.xOffset = 0
        return l
    }()

    public var horizontal: LimitLine? {
        if showHorizontal && (point?.y) != nil {
            return _horizontal
        } else {
            return nil
        }
    }

    var _vertical: LimitLine = {
        let l = LimitLine(0, .vertical)
        object_setClass(l.limitLine, KLCrosshairLimitLine.self)
        l.limitLine.labelPosition = .bottomLeft
        l.limitLine.yOffset = 20
        l.limitLine.xOffset = -32
        l.limitLine.drawLabelEnabled = false
        l.label.bgColor = 0x0188ff.toColor
        l.label.color = UIColor.white
        l.label.font = UIFont.boldSystemFont(ofSize: 9)
        return l
    }()

    public var vertical: LimitLine? {
        if point?.x != nil  {
            return _vertical
        } else {
            return nil
        }
    }

}

extension Crosshair: KLIndicator {
    public static var style: KLStyle = KLStyle.default
}
