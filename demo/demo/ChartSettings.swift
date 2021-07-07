//
//  ChartSettings.swift
//  demo
//
//  Created by pikacode on 2021/6/22.
//

import UIKit
import KLine

struct KPriceLine {
    var label = ""
    var color = 0x00000000
    var value: Double = 0
    var enabled = false
}

class ChartSettings {

    static var shared = readFromLocal()

    var changed = { (s: ChartSettings) in } {
        didSet {
            if effectImmediately {
                changed(self)
            }
        }
    }

    var effectImmediately = true

    var mainHeight: CGFloat = 282 { didSet{ save() } }

    var mainIndicators: [(indicator: KLIndicator, on: Bool)] = [(MA(), true),
                                                                (EMA(), false),
                                                                (BOLL(), false)] { didSet{ save() } }

    var otherIndicators: [(indicator: KLIndicator, on: Bool)] = [(MAVOL(), true),
                                                                 (MACD(), true),
                                                                 (KDJ(), false),
                                                                 (RSI(), false)] { didSet{ save() } }

    var priceLines = [KPriceLine(label: "价格线", color: 0xffffff99, value: Double.random(in: 100...500), enabled: true),
                      KPriceLine(label: "指数线", color: 0x0077f3ff, value: Double.random(in: 100...500), enabled: true),
                      KPriceLine(label: "强平线", color: 0x8080ffff, value: Double.random(in: 100...500), enabled: false),
                      KPriceLine(label: "持仓线", color: 0xecc413ff, value: Double.random(in: 100...500), enabled: false),
                      KPriceLine(label: "止盈线", color: 0xcf780bff, value: Double.random(in: 100...500), enabled: true),
                      KPriceLine(label: "止损线", color: 0xf600ffff, value: Double.random(in: 100...500), enabled: false),
                      KPriceLine(label: "网格线", color: 0xffffff00, value: Double.random(in: 100...500), enabled: true),]
    { didSet{ save() } }

    static func readFromLocal() -> ChartSettings {
        // read from local
        return ChartSettings()
    }

    func save() {
        changed(self)
        // save to local

    }



}
