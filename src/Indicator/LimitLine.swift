//
//  LimitLine.swift
//  KLine
//
//  Created by pikacode on 2021/6/18.
//

import UIKit

public struct LimitLine: KLIndicator {

    public static var style: KLStyle = KLStyle.default

    public var value: CGFloat = 0

    public var direction = KLDirection.horizontal

    public var dashLengths = [CGFloat]()
    public var dashPhase = CGFloat.zero

    public var lineColor: UIColor { return LimitLine.style.lineColor1 }
    public var lineWidth: CGFloat { return LimitLine.style.lineWidth1 }
    public var label: KLLabel { return LimitLine.style.label }

}
