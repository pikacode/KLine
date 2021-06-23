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
        
    
    //MACD技术指标
    public var dif: Double = 0.0
    public var dea: Double = 0.0
    public var small_macd: Double = 0.0
    public var big_macd: Double = 0.0
    public var macd_macd: Double = 0.0
    

    //KDJ技术指标
    public var k: Double = 0.0
    public var d: Double = 0.0
    public var j: Double = 0.0
    public var rsv: Double = 0.0

    /// 对时间戳的缩放  x = timeInterval / timeXScale
    public static var timeXScale: Double = 50000

    public var x: Double {
        return time/KLineData.timeXScale
    }

    public var ma: MA? //简单移动平均数
    public var ema: EMA? //指数移动平均数
    public var boll: BOLL? //布林数
    //附图
    public var macd: MACD? //指数平滑异同平均线
    public var kdj: KDJ? //随机指标
    public var rsi: RSI? //相对强弱指标

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

