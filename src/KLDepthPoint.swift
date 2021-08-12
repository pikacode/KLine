//
//  KLDepthPoint.swift
//  KLine
//
//  Created by pikacode on 2021/6/21.
//

import UIKit
open class KLDepthPoint {
//open class KLDepthPoint {
    public enum TradingType {
        case buy
        case sell
    }

    public var type: TradingType = .buy
    
    public var price: Double = 0
    
    public var depthNum: Double = 0
    
    public var amount: Double = 0
    
    public var x: Double = 0
    
    
    public init(p: Double, t: TradingType, a: Double, x: Double) {
        price = p
        amount = a
        type = t
        self.x = x
    }
    
    
}

