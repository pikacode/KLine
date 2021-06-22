//
//  KLYAxisRenderer.swift
//  KLine
//
//  Created by pikacode on 2021/6/21.
//

import UIKit
import Charts

open class KLYAxisRenderer: YAxisRenderer {

    open override func renderLimitLines(context: CGContext) {
        guard
            let yAxis = self.axis as? YAxis,
            let transformer = self.transformer
            else { return }

        let limitLines = yAxis.limitLines

        if limitLines.count == 0
        {
            return
        }

        context.saveGState()

        let trans = transformer.valueToPixelMatrix

        var position = CGPoint(x: 0.0, y: 0.0)

        for i in 0 ..< limitLines.count
        {

            let l = limitLines[i]

            if !l.isEnabled
            {
                continue
            }

            var attributes = [NSAttributedString.Key.font: l.valueFont,
                              NSAttributedString.Key.foregroundColor: l.valueTextColor]
            if let l1 = l as? KLChartLimitLine {
                attributes[.backgroundColor] = l1.bgColor
            }

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
            if l.drawLabelEnabled && label.count > 0
            {
                let labelLineHeight = l.valueFont.lineHeight

                let xOffset: CGFloat = 4.0 + l.xOffset
                let yOffset: CGFloat = l.lineWidth + labelLineHeight + l.yOffset

                if l.labelPosition == .topRight
                {
                    ChartUtils.drawText(context: context,
                        text: label,
                        point: CGPoint(
                            x: viewPortHandler.contentRight - xOffset,
                            y: position.y - yOffset),
                        align: .right,
                        attributes: attributes)
                }
                else if l.labelPosition == .bottomRight
                {
                    ChartUtils.drawText(context: context,
                        text: label,
                        point: CGPoint(
                            x: viewPortHandler.contentRight - xOffset,
                            y: position.y + yOffset - labelLineHeight),
                        align: .right,
                        attributes: attributes)
                }
                else if l.labelPosition == .topLeft
                {
                    ChartUtils.drawText(context: context,
                        text: label,
                        point: CGPoint(
                            x: viewPortHandler.contentLeft + xOffset,
                            y: position.y - yOffset),
                        align: .left,
                        attributes: attributes)
                }
                else
                {
                    ChartUtils.drawText(context: context,
                        text: label,
                        point: CGPoint(
                            x: viewPortHandler.contentLeft + xOffset,
                            y: position.y + yOffset - labelLineHeight),
                        align: .left,
                        attributes: attributes)
                }
            }
        }

        context.restoreGState()

        
    }

}
