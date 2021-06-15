//
//  KLineData.swift
//  KLine
//
//  Created by pikacode on 2021/6/2.
//

import UIKit

open class KLineData {
    public var open: Double = 0
    public var close: Double = 0
    public var high: Double = 0
    public var low: Double = 0
    public var vol: Double = 0
    public var time: TimeInterval = 0

    public var ma: MA?

    public init(o: Double, c: Double, h: Double, l: Double, v: Double, t: TimeInterval) {
        open = o
        close = c
        high = h
        low = l
        vol = v
        time = t
    }
}

extension KLineData: Equatable {

    public static func == (lhs: KLineData, rhs: KLineData) -> Bool {
        return lhs.time == rhs.time && lhs.open == rhs.open && lhs.vol == rhs.vol
    }

    public static func != (lhs: KLineData, rhs: KLineData) -> Bool {
        return !(lhs == rhs)
    }
}

