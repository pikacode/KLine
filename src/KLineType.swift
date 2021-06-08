//
//  KLineType.swift
//  Kline
//
//  Created by pikacode on 2021/6/1.
//

import UIKit

//图表类型
public enum KLineType: CaseIterable {
    case min //分时图
    case candle //蜡烛图
    case mavol
    case vol //成交量
    case macd
    case kdj
    case rsi
    case ma
    case ema
    case boll
    case depth //深度图
    case custom

    public var style: KLStyle {
        get {
            return KLineType.styles[self]!
        }
        set {
            KLineType.styles[self] = newValue
        }
    }

    static var styles = KLineType.allCases.reduce(into: [KLineType : KLStyle]()) { $0[$1] = $1.style }

}

