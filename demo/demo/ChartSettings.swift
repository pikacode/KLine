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

    var mainIndicators = [(MA(), true),
                          (EMA(), false),
                          (BOLL(), false)]
    as [(indicator: KLIndicator, on: Bool)] { didSet{ save() } }

    var otherIndicators = [(MAVOL(), true),
                           (MACD(), true),
                           (KDJ(), false),
                           (RSI(), false)]
    as [(indicator: KLIndicator, on: Bool)] { didSet{ save() } }

    var priceLines = [("价格线", 0xffffff99, true),
                      ("指数线", 0x0077f3ff, false),
                      ("强平线", 0x8080ffff, true),
                      ("持仓线", 0xecc413ff, true),
                      ("止盈线", 0xcf780bff, false),
                      ("止损线", 0xf600ffff, false),
                      ("网格线", 0xffffff00, true)]
    .map{
        KPriceLine(label: $0.0, color: $0.1, value: Double.random(in: 150...450), enabled: $0.2)
    } { didSet{ save() } }

    static func readFromLocal() -> ChartSettings {
        // read from local
        return ChartSettings()
    }

    func save() {
        changed(self)
        // save to local

    }

}
