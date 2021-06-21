//
//  KLineStyle.swift
//  KLine
//
//  Created by pikacode on 2021/6/1.
//

import UIKit

open class KLStyle {

    public static var `default` = KLStyle(true)

    public var lineWidth1: CGFloat

    public var maxBarWidth: CGFloat
    public var minBarWidth: CGFloat

    public var space: CGFloat

    public var lineColor1: UIColor
    public var lineColor2: UIColor
    public var lineColor3: UIColor

    public var upColor: UIColor
    public var downColor: UIColor
    
    public var upBarColor: UIColor
    public var downBarColor: UIColor

    public var upGradient: GradientColor
    public var downGradient: GradientColor

    public var label: KLLabel

    public struct GradientColor {
        let top: UIColor
        let bottom: UIColor
    }

    public init(_ isDefault: Bool = false) {
        if isDefault {
            lineWidth1 = 1
            maxBarWidth = 4
            minBarWidth = 1
            space = 1
            lineColor1 = 0x039fff.toColor
            lineColor2 = 0x01d0f7.toColor
            lineColor3 = 0xff7401.toColor
            upColor = 0x02cc99.toColor
            downColor = 0xff2500.toColor
            upBarColor = 0xC33137.toColor
            downBarColor = 0x37A783.toColor
            upGradient = GradientColor(top: upColor.alpha(0.8), bottom: upColor.alpha(0.1))
            downGradient = GradientColor(top: downColor.alpha(0.8), bottom: downColor.alpha(0.1))
            label = KLLabel(text: "", font: UIFont.systemFont(ofSize: 10), color: UIColor.black, bgColor: UIColor.white, position: KLPosition.left(.zero))
        } else {
            let style = KLStyle.default
            lineWidth1 = style.lineWidth1
            maxBarWidth = style.maxBarWidth
            minBarWidth = style.minBarWidth
            space = style.space
            lineColor1 = style.lineColor1
            lineColor2 = style.lineColor2
            lineColor3 = style.lineColor3
            upColor = style.upColor
            downColor = style.downColor
            upBarColor = style.upBarColor
            downBarColor = style.downBarColor
            upGradient = style.upGradient
            downGradient = style.downGradient
            label = style.label
        }
    }

}
