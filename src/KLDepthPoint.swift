//
//  KLDepthPoint.swift
//  KLine
//
//  Created by pikacode on 2021/6/21.
//

import UIKit

public struct KLDepthPoint: KLPoint {
    public enum TradingType {
        case buy
        case sell
    }
    public var x: CGFloat = 0

    public var y: CGFloat = 0

    public var direction: KLOrderDirection
    
    public var type: TradingType = .buy
    
    public var vol: Double = 0
    
    public var price: Double = 0
    
    public var depthNum: Double = 0
    
}

