//
//  KLCandleStickChartRenderer.swift
//  KLine
//
//  Created by pikacode on 2021/8/20.
//

import UIKit
import Charts

class KLCandleStickChartRenderer: CandleStickChartRenderer {

    open override func drawValues(context: CGContext)
    {

        guard
            let dataProvider = dataProvider,
            let candleData = dataProvider.candleData
        else { return }


        let dataSets = candleData.dataSets

        let phaseY = animator.phaseY

        var pt = CGPoint()

        for i in 0 ..< dataSets.count
        {
            guard let
                    dataSet = dataSets[i] as? CandleChartDataSet,
                  shouldDrawValues(forDataSet: dataSet)
            else { continue }

            let valueFont = dataSet.valueFont

            guard let formatter = dataSet.valueFormatter as? KLCandleValueFormatter else { continue }

            let trans = dataProvider.getTransformer(forAxis: dataSet.axisDependency)
            let valueToPixelMatrix = trans.valueToPixelMatrix

            let iconsOffset = dataSet.iconsOffset

            _xBounds.set(chart: dataProvider, dataSet: dataSet, animator: animator)

            let lineHeight = valueFont.lineHeight
            var yOffset: CGFloat = lineHeight + 5.0

            let es = dataSet.entries[(_xBounds.min+1)...(_xBounds.max-1)].compactMap{ $0 as? CandleChartDataEntry }
            guard let max = es.max { $0.high < $1.high },
                  let min = es.min { $0.low < $1.low },
                  let maxIndex = es.firstIndex(of: max),
                  let minIndex = es.firstIndex(of: min) else {
                    return
                  }

//            let maxLeft = maxIndex < (_xBounds.max - _xBounds.min) / 2
//            let minLeft = minIndex < (_xBounds.max - _xBounds.min) / 2

            let maxLeft = maxIndex < minIndex
            let minLeft = minIndex < maxIndex

            for j in _xBounds
            {
                guard let e = dataSet.entryForIndex(j) as? CandleChartDataEntry else { break }

                pt.x = CGFloat(e.x)
                pt.y = CGFloat(e.high * phaseY)
                pt = pt.applying(valueToPixelMatrix)

                if (!viewPortHandler.isInBoundsRight(pt.x))
                {
                    break
                }

                if (!viewPortHandler.isInBoundsLeft(pt.x) || !viewPortHandler.isInBoundsY(pt.y))
                {
                    continue
                }

                if dataSet.isDrawValuesEnabled && (e == max || e == min)
                {
                    if e == max {
                        yOffset = -7

                        ChartUtils.drawText(
                            context: context,
                            text: formatter.stringForValue(value: e.high, left: maxLeft),
                            point: CGPoint(
                                x: pt.x,
                                y: pt.y + yOffset),
                            align: maxLeft ? .left : .right,
                            attributes: [NSAttributedString.Key.font: valueFont, NSAttributedString.Key.foregroundColor: dataSet.valueTextColorAt(j)])
                    } else {
                        var p = CGPoint()
                        p.y = CGFloat(e.low * phaseY)
                        p = p.applying(valueToPixelMatrix)
                        yOffset = p.y - pt.y - 7

                        ChartUtils.drawText(
                            context: context,
                            text: formatter.stringForValue(value: e.low, left: minLeft),
                            point: CGPoint(
                                x: pt.x,
                                y: pt.y + yOffset),
                            align: minLeft ? .left : .right,
                            attributes: [NSAttributedString.Key.font: valueFont, NSAttributedString.Key.foregroundColor: dataSet.valueTextColorAt(j)])
                    }
                }

                if let icon = e.icon, dataSet.isDrawIconsEnabled
                {
                    ChartUtils.drawImage(context: context,
                                         image: icon,
                                         x: pt.x + iconsOffset.x,
                                         y: pt.y + iconsOffset.y,
                                         size: icon.size)
                }
            }
        }

    }

}
