//
//  RSI.swift
//  KLine
//
//  Created by aax1 on 2021/6/18.
//

import UIKit

open class RSI {

    required public init() {}
    public static var days = [6, 12, 24]
    
    //RSI指标参数
    var up_avg_6: Double   = 0
    var up_avg_12: Double  = 0
    var up_avg_24: Double  = 0
    var dn_avg_6: Double   = 0
    var dn_avg_12: Double  = 0
    var dn_avg_24: Double  = 0
    var rsi6: Double       = 0
    var rsi12: Double      = 0
    var rsi24: Double      = 0
    
     
  
    
}


extension RSI: KLIndicator{

    public static var style: KLStyle = KLStyle.default
    public func calculate(_ data: inout [Any]) {
//        guard let data = data as? [KLineData] else { return }
        
    }
    
    
}
