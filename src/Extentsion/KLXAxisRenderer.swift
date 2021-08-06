//
//  KLXAxisRenderer.swift
//  KLine
//
//  Created by pikacode on 2021/8/6.
//

import UIKit
import Charts

open class KLXAxisRenderer: XAxisRenderer {

    @objc open override func renderLimitLineLabel(context: CGContext, limitLine: ChartLimitLine, position: CGPoint, yOffset: CGFloat)
    {

        let label = limitLine.label
        guard limitLine.drawLabelEnabled, !label.isEmpty else { return }

        let labelLineHeight = limitLine.valueFont.lineHeight

        let xOffset: CGFloat = limitLine.lineWidth + limitLine.xOffset
        var attributes: [NSAttributedString.Key : Any] = [
            .font : limitLine.valueFont,
            .foregroundColor : limitLine.valueTextColor
        ]

        //kline
        if let l1 = limitLine as? KLChartLimitLine {
            attributes[.backgroundColor] = l1.bgColor
        }
        //kline

        let (point, align): (CGPoint, NSTextAlignment)
        switch limitLine.labelPosition {
        case .topRight:
            point = CGPoint(
                x: position.x + xOffset,
                y: viewPortHandler.contentTop + yOffset
            )
            align = .left

        case .bottomRight:
            point = CGPoint(
                x: position.x + xOffset,
                y: viewPortHandler.contentBottom - labelLineHeight - yOffset
            )
            align = .left

        case .topLeft:
            point = CGPoint(
                x: position.x - xOffset,
                y: viewPortHandler.contentTop + yOffset
            )
            align = .right

        case .bottomLeft:
            point = CGPoint(
                x: position.x - xOffset,
                y: viewPortHandler.contentBottom - labelLineHeight - yOffset
            )
            align = .right
        }

        ChartUtils.drawText(
            context: context,
            text: label,
            point: point,
            align: align,
            attributes: attributes
        )
    }
    
}
