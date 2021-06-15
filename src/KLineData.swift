//
//  KLineData.swift
//  KLine
//
//  Created by pikacode on 2021/6/2.
//

import UIKit

open class KLineData {
    var open: CGFloat = 0
    var high: CGFloat = 0
    var time: CGFloat = 0
    var low: CGFloat = 0
    var vol: CGFloat = 0
    var close: CGFloat = 0

    var ma = MA()
}

extension KLineData: Equatable {

    public static func == (lhs: KLineData, rhs: KLineData) -> Bool {
        return lhs.time == rhs.time && lhs.open == rhs.open && lhs.vol == rhs.vol
    }

    public static func != (lhs: KLineData, rhs: KLineData) -> Bool {
        return !(lhs == rhs)
    }
}

open class MA {
    var _7: Double = 0
    var _25: Double = 0
    var _60: Double = 0
}
