//
//  KLineData.swift
//  KLine
//
//  Created by pikacode on 2021/6/2.
//

import UIKit

open class KLineData {
    var open: Double = 0
    var high: Double = 0
    var time: Double = 0
    var low: Double = 0
    var vol: Double = 0
    var close: Double = 0

    var ma: MA?
}

extension KLineData: Equatable {

    public static func == (lhs: KLineData, rhs: KLineData) -> Bool {
        return lhs.time == rhs.time && lhs.open == rhs.open && lhs.vol == rhs.vol
    }

    public static func != (lhs: KLineData, rhs: KLineData) -> Bool {
        return !(lhs == rhs)
    }
}

