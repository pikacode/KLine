//
//  ChartSettings.swift
//  demo
//
//  Created by pikacode on 2021/6/22.
//

import UIKit
import KLine

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
    var mainIndicators: [(KLIndicator, Bool)] = [(MA(), true),
                                                 (EMA(), false),
                                                 (BOLL(), false)] { didSet{ save() } }
    var otherIndicators: [(KLIndicator, Bool)] = [(MAVOL(), true),
                                                  (MACD(), true),
                                                  (KDJ(), false),
                                                  (RSI(), false)] { didSet{ save() } }
    var switchs = [true, true, false, false, false, false, true] { didSet{ save() } }

    static func readFromLocal() -> ChartSettings {
        // read from local
        return ChartSettings()
    }

    func save() {
        changed(self)
        // save to local

    }



}
