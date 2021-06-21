//
//  LimitLine.swift
//  KLine
//
//  Created by pikacode on 2021/6/18.
//

import UIKit

///水平线 | 垂直线
public struct LimitLine {

    public static var style: KLStyle = KLStyle.default

    public var value: CGFloat = 0

    public var direction = KLDirection.horizontal

    public var dashLengths = [CGFloat]()
    public var dashPhase = CGFloat.zero

    public var lineColor: UIColor { return LimitLine.style.lineColor1 }
    public var lineWidth: CGFloat { return LimitLine.style.lineWidth1 }
    public var label: KLLabel { return LimitLine.style.label }

}

extension LimitLine: KLIndicator {
//    public static func lineDataSet(points data: [KLPoint]) -> [LineChartDataSet]? {
//        var line = LimitLine()
//        if let p1 = data[0~], let p2 = data[1~] {
//            if p1.x == p2.x {
//                line.direction = .vertical
//                line.value = p1.x
//            } else if p1.y == p2.y {
//                line.direction = .horizontal
//                line.value = p1.y
//            } else {
//                line.direction = .horizontal
//                line.value = p1.y
//            }
//        } else if let p1 = data[0~] {
//            line.direction = .horizontal
//            line.value = p1.y
//        } else {
//            return nil
//        }
//    }
}
