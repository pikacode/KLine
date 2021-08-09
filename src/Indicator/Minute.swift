//
//  Minute.swift
//  KLine
//
//  Created by pikacode on 2021/8/9.
//

import UIKit
import Charts

open class Minute: KLIndicator {
    
    required public init() {}

    public static var style: KLStyle = {
        let s = KLStyle.default
        s.lineColor1 = 0x0188ff.toColor
        s.lineColor2 = 0xac027deb.toColor
        s.lineColor3 = 0x00000000.toColor.alpha(0)
        return s
    }()

    public func lineDataSet(_ data: [Any]) -> [LineChartDataSet]? {
        guard let data = data as? [KLineData] else { return nil }
        let entries = data.map{
            ChartDataEntry(x: $0.x, y: $0.close)
        }
        let set = LineChartDataSet(entries: entries, label: "")

        set.colors = [style.lineColor1]
        set.valueFont = .systemFont(ofSize: 10)
        set.drawValuesEnabled = false
        set.circleRadius = 0
        set.circleHoleRadius = 0

        set.lineWidth = style.lineWidth1
        set.drawFilledEnabled = true
        set.drawValuesEnabled = false

        set.axisDependency = .left
        if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [style.lineColor2.cgColor, style.lineColor3.cgColor] as CFArray, locations: [1, 0]) {

            set.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
        }
        return [set]
    }

}
