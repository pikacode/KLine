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
        style.height = 100
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

    public var height: CGFloat

    public var lineWidth1: CGFloat

    public var maxBarWidth: CGFloat
    public var minBarWidth: CGFloat

    public var space: CGFloat

    public var lineColor1: UIColor
    public var lineColor2: UIColor
    public var lineColor3: UIColor

    public var upColor: UIColor
    public var downColor: UIColor

    public var upGradient: GradientColor
    public var downGradient: GradientColor 

    public struct GradientColor {
        let top: UIColor
        let bottom: UIColor
    }

    public init() {
        let style = KLStyle.default
        height = style.height
        lineWidth1 = style.lineWidth1
        maxBarWidth = style.maxBarWidth
        minBarWidth = style.minBarWidth
        space = style.space
        lineColor1 = style.lineColor1
        lineColor2 = style.lineColor2
        lineColor3 = style.lineColor3
        upColor = style.upColor
        downColor = style.downColor
        upGradient = style.upGradient
        downGradient = style.downGradient
    }

}
