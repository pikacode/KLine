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
            draw()
        }
    }

    public var height: CGFloat

    var offset: CGFloat = 0


    public init(_ indicators: [KLIndicator.Type], _ height: CGFloat) {
        self.indicators = indicators
        self.height = height
    }

    let chartView = KLCombinedChartView(frame: .zero)

    func draw() {
        
    }

}
