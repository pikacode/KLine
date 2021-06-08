//
//  KLineStyle.swift
//  KLine
//
//  Created by pikacode on 2021/6/1.
//

import UIKit

protocol KLStyleElement {}

open class KLStyle {

    static var lineWidth1 = CGFloat(1)
    static var maxBarWidth = CGFloat(4)
    static var minBarWidth = CGFloat(1)
    static var space = CGFloat(1)
    static var lineColor1 = UIColor.white
    static var lineColor2 = UIColor.white
    static var lineColor3 = UIColor.white
    static var upColor = UIColor.white
    static var downColor = UIColor.white
    static var upGradient = GradientColor(top: upColor.alpha(0.8), bottom: upColor.alpha(0.1))
    static var downGradient = GradientColor(top: downColor.alpha(0.8), bottom: downColor.alpha(0.1))

    struct GradientColor {
        let top: UIColor
        let bottom: UIColor
    }

//    static var min = GradientLine(line: .long, gradient: longGradient)
//
//    static var candle = Candle(longColor: longColor,
//                               shortColor: shortColor,
//                               maxWidth: lineWidth2,
//                               minWidth: lineWidth1,
//                               lineWidth: lineWidth1,
//                               space: lineWidth1)
//
//    static var ma: [Line] = [.l1, .l2, .l3]
//    static var ema: [Line] = [.l1, .l2, .l3]
//    static var boll: [Line] = [.l1, .l2, .l3]
//    static var mavol: [KLineStyleElement] = [Line.l1, Line.l2, Line.l3, Bar]
//    static var vol: Bar
//    static var macd: ([Line], Bar)
//    static var kdj: [Line]
//    static var rsi: [Line]
//    static var depth: (up: GradientLine, down: GradientLine)
//    static var customs: [KLineStyleElement]
//
//    struct GradientLine: KLineStyleElement {
//        let line: Line
//        let gradient: GradientColor
//        static var long: GradientLine { return GradientLine(line: .long, gradient: KLineStyle.longGradient) }
//        static var short: GradientLine { return GradientLine(line: .short, gradient: KLineStyle.shortGradient) }
//    }
//

//
//    struct Candle: KLineStyleElement {
//        let longColor: UIColor
//        let shortColor: UIColor
//        let maxWidth: CGFloat
//        let minWidth: CGFloat
//        let lineWidth: CGFloat
//        let space: CGFloat
//    }
//
//    struct Line: KLineStyleElement {
//        let color: UIColor
//        let width: CGFloat
//
//        static var l1: Line { return Line(color: KLineStyle.lineColor1, width: KLineStyle.lineWidth1) }
//        static var l2: Line { return Line(color: KLineStyle.lineColor2, width: KLineStyle.lineWidth1) }
//        static var l3: Line { return Line(color: KLineStyle.lineColor3, width: KLineStyle.lineWidth1) }
//        static var long: Line { return Line(color: KLineStyle.longColor, width: KLineStyle.lineWidth1) }
//        static var short: Line { return Line(color: KLineStyle.shortColor, width: KLineStyle.lineWidth1) }
//    }
//
//    struct Bar: KLineStyleElement {
//        let upColor: UIColor
//        let downColor: UIColor
//    }

}
