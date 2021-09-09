//
//  KLDefaultAxisValueFormatter.swift
//  KLine
//
//  Created by pikacode on 2021/9/9.
//

import UIKit
import Charts

class KLDefaultAxisValueFormatter: DefaultAxisValueFormatter {
    open override func stringForValue(_ value: Double,
                               axis: AxisBase?) -> String
    {
        formatter?.minimumFractionDigits = KLineView.precision
        formatter?.maximumFractionDigits = KLineView.precision
        formatter?.numberStyle = .decimal
        if let block = block {
            return block(value, axis)
        } else {
            return formatter?.string(from: NSNumber(floatLiteral: value)) ?? ""
        }
    }
}
