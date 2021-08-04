//
//  KLYAxisRenderer.swift
//  KLine
//
//  Created by pikacode on 2021/6/21.
//

import UIKit
import Charts

open class KLYAxisRenderer: YAxisRenderer {

    open override func renderLimitLines(context: CGContext)
    {
        guard let transformer = self.transformer else { return }

        let limitLines = axis.limitLines

        guard !limitLines.isEmpty else { return }

        context.saveGState()
        defer { context.restoreGState() }

        let trans = transformer.valueToPixelMatrix

        var position = CGPoint(x: 0.0, y: 0.0)

        for l in limitLines where l.isEnabled
        {
            context.saveGState()
            defer { context.restoreGState() }

            var clippingRect = viewPortHandler.contentRect
            clippingRect.origin.y -= l.lineWidth / 2.0
            clippingRect.size.height += l.lineWidth
            context.clip(to: clippingRect)

            position.x = 0.0
            position.y = CGFloat(l.limit)
            position = position.applying(trans)

            context.beginPath()
            context.move(to: CGPoint(x: viewPortHandler.contentLeft, y: position.y))
            context.addLine(to: CGPoint(x: viewPortHandler.contentRight, y: position.y))

            context.setStrokeColor(l.lineColor.cgColor)
            context.setLineWidth(l.lineWidth)
            if l.lineDashLengths != nil
            {
                context.setLineDash(phase: l.lineDashPhase, lengths: l.lineDashLengths!)
            }
            else
            {
                context.setLineDash(phase: 0.0, lengths: [])
            }

            context.strokePath()

            let label = l.label

            // if drawing the limit-value label is enabled
            guard l.drawLabelEnabled, !label.isEmpty else { continue }

            let labelLineHeight = l.valueFont.lineHeight

            let xOffset = 4.0 + l.xOffset
            let yOffset = l.lineWidth + labelLineHeight + l.yOffset

            let align: TextAlignment
            let point: CGPoint

            switch l.labelPosition
            {
            case .rightTop:
                align = .right
                point = CGPoint(x: viewPortHandler.contentRight - xOffset,
                                y: position.y - yOffset)

            case .rightBottom:
                align = .right
                point = CGPoint(x: viewPortHandler.contentRight - xOffset,
                                y: position.y + yOffset - labelLineHeight)

            case .leftTop:
                align = .left
                point = CGPoint(x: viewPortHandler.contentLeft + xOffset,
                                y: position.y - yOffset)

            case .leftBottom:
                align = .left
                point = CGPoint(x: viewPortHandler.contentLeft + xOffset,
                                y: position.y + yOffset - labelLineHeight)
            }

            //kline add
            var attributes = [NSAttributedString.Key.font: l.valueFont,
                              NSAttributedString.Key.foregroundColor: l.valueTextColor]
            if let l1 = l as? KLChartLimitLine {
                attributes[.backgroundColor] = l1.bgColor
            }
            //kline add

            context.drawText(label,
                             at: point,
                             align: align,
                             attributes: attributes)
        }
    }

}
