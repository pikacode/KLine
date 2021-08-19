//
//  KLLegendRenderer.swift
//  KLine
//
//  Created by pikacode on 2021/6/17.
//

import UIKit
import Charts

open class KLLegendRenderer: LegendRenderer {

    static var index: Int?
    
    @objc open override func drawLabel(context: CGContext, x: CGFloat, y: CGFloat, label: String, font: NSUIFont, textColor: NSUIColor) {
        
        guard let entries = legend?.entries,
            let e = entries.first(where: { $0.label == label }),
            let color = e.formColor else {
            super.drawLabel(context: context, x: x, y: y, label: label, font: font, textColor: textColor)
            return
        }
        super.drawLabel(context: context, x: x, y: y, label: label, font: font, textColor: color)
    }

}
