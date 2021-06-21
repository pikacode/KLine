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

    public var value: Double

    public var direction: KLDirection

    public var dashLengths = [CGFloat]()
    public var dashPhase = CGFloat.zero

    public var lineColor: UIColor { return LimitLine.style.lineColor1 }
    public var lineWidth: CGFloat { return LimitLine.style.lineWidth1 }
    public var label: KLLabel { return LimitLine.style.label }

    public init(_ value: Double, _ direction: KLDirection) {
        self.value = value
        self.direction = direction
    }
}

extension LimitLine: KLIndicator {}
