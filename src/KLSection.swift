//
//  KLSection.swift
//  KLine
//
//  Created by pikacode on 2021/6/15.
//

import UIKit

open class KLSection {

    public var indicators: [KLIndicator.Type] {
        didSet {
            draw(data)
        }
    }

    public var height: CGFloat

    var offset: CGFloat = 0

    var data = [KLineData]()

    public init(_ indicators: [KLIndicator.Type], _ height: CGFloat) {
        self.indicators = indicators
        self.height = height
    }

    let chartView = KLCombinedChartView(frame: .zero)

    func draw(_ data: [KLineData]) {
        self.data = data
        indicators.forEach {
            switch $0.name {
            case Candle.name:
                break

            case MA.name:
                break

            default:
                break
            }
        }
    }

}
