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

    private var changedBlocks = [(dependence: NSObject?, block: (ChartSettings)->())]() {
        didSet {
            changedBlocks.removeAll{ $0.dependence == nil }
            if effectImmediately {
                changedBlocks.forEach{ $0.block(self) }
            }
        }
    }

    func changed(dependence: NSObject?, _ block: @escaping (ChartSettings)->()) {
        changedBlocks.removeAll(where: { $0.dependence == dependence })
        changedBlocks.append((dependence, block))
    }

    var effectImmediately = true

    var mainHeight: CGFloat = 282 { didSet{ save() } }

    let mainHeights: [CGFloat] = [182, 282, 382]

    var mainIndicators = [(MA(), true),
                          (EMA(), false),
                          (BOLL(), false),
                          (Candle(), true),]
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
        guard let str = UserDefaults.standard.value(forKey: userDefaultsKey) as? String,
              let data = str.data(using: .utf8),
              let dict = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any]
        else {
            return ChartSettings()
        }
        let settings = ChartSettings()

        if let h = dict["mainHeight"] as? CGFloat {
            settings.mainHeight = h
        }

        (dict["mainIndicators"] as? [String: Bool])?.forEach{ pair in
            let name = pair.key
            let on = pair.value
            if let index = settings.mainIndicators.firstIndex(where: { $0.indicator.name == name }) {
                let item = settings.mainIndicators[index]
                settings.mainIndicators[index] = (item.indicator, on)
            }
        }

        (dict["otherIndicators"] as? [String: Bool])?.forEach{ pair in
            let name = pair.key
            let on = pair.value
            if let index = settings.otherIndicators.firstIndex(where: { $0.indicator.name == name }) {
                let item = settings.otherIndicators[index]
                settings.otherIndicators[index] = (item.indicator, on)
            }
        }

        (dict["priceLines"] as? [String: Bool])?.forEach{ pair in
            let name = pair.key
            let on = pair.value
            if let index = settings.priceLines.firstIndex(where: { $0.label == name }) {
                let item = settings.priceLines[index]
                settings.priceLines[index] = KPriceLine(label: name, color: item.color, value: item.value, enabled: on)
            }
        }

        return settings
    }

    static let userDefaultsKey = "chartsettingsKey"

    func save() {
        // trigger changed
        changedBlocks.forEach{ $0.block(self) }

        // save to local
        var dict = [String : Any]()
        dict["mainHeight"] = mainHeight
        dict["mainIndicators"] = mainIndicators.reduce(into: [String: Bool](), {
            $0[$1.indicator.name] = $1.on
        })
        dict["otherIndicators"] = otherIndicators.reduce(into: [String: Bool](), {
            $0[$1.indicator.name] = $1.on
        })
        dict["priceLines"] = priceLines.reduce(into: [String: Bool](), {
            $0[$1.label] = $1.enabled
        })

        if let data = try? JSONSerialization.data(withJSONObject: dict, options: .fragmentsAllowed) {
            let str = String(data: data, encoding: .utf8)
            UserDefaults.standard.setValue(str, forKey: ChartSettings.userDefaultsKey)
        }
    }

}
