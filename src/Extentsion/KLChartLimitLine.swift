//
//  KLChartLimitLine.swift
//  KLine
//
//  Created by pikacode on 2021/6/21.
//

import UIKit
import Charts

open class KLChartLimitLine: ChartLimitLine {
    public var bgColor = LimitLine.style.label.bgColor
}

open class KLCrosshairLimitLine: KLChartLimitLine {}

extension ChartLimitLine {
    var isCrosshair: Bool {
        return self is KLCrosshairLimitLine
    }
}
