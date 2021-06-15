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
    case ma
    case ema
    case boll
    case mavol
    case macd
    case kdj
    case rsi
    case vol //成交量
    case depth //深度图
    case custom

    public var style: KLStyle {
        get {
            return KLineType.styles[self] ?? KLStyle()
        }
        set {
            KLineType.styles[self] = newValue
        }
    }

    public static var styles = KLineType.allCases.reduce(into: [KLineType : KLStyle]()) { $0[$1] = $1.style }

    public func calculate(_ data: inout [KLineData]) {
        switch self {
        case .ma:
            
            break

        case .ema:
            break

        case .boll:
            break

        case .mavol:
            break

        case .macd:
            break

        case .kdj:
            break

        case .rsi:
            break

        case .vol:
            break

        case .depth:
            break

        default:
            break
        }

    }

}

