//
//  KLineStyle.swift
//  KLine
//
//  Created by pikacode on 2021/6/1.
//

import UIKit

open class KLStyle {

    public static var `default`: KLStyle = {
        let style = KLStyle()
        style.lineWidth1 = 1
        style.maxBarWidth = 4
        style.minBarWidth = 1
        style.space = 1
        style.lineColor1 = UIColor.white
        style.lineColor2 = UIColor.white
        style.lineColor3 = UIColor.white
        style.upColor = UIColor.white
        style.downColor = UIColor.white
        style.upGradient = GradientColor(top: style.upColor.alpha(0.8), bottom: style.upColor.alpha(0.1))
        style.downGradient = GradientColor(top: style.downColor.alpha(0.8), bottom: style.downColor.alpha(0.1))
        return style
    }()

    public var lineWidth1: CGFloat = KLStyle.default.lineWidth1

    public var maxBarWidth: CGFloat = KLStyle.default.maxBarWidth
    public var minBarWidth: CGFloat = KLStyle.default.minBarWidth

    public var space: CGFloat = KLStyle.default.space

    public var lineColor1: UIColor = KLStyle.default.lineColor1
    public var lineColor2: UIColor = KLStyle.default.lineColor2
    public var lineColor3: UIColor = KLStyle.default.lineColor3

    public var upColor: UIColor = KLStyle.default.upColor
    public var downColor: UIColor = KLStyle.default.downColor

    public var upGradient: GradientColor = KLStyle.default.upGradient
    public var downGradient: GradientColor = KLStyle.default.downGradient

    public struct GradientColor {
        let top: UIColor
        let bottom: UIColor
    }

}
