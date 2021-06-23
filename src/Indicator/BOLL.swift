//
//  BOLL.swift
//  KLine
//
//  Created by aax1 on 2021/6/23.
//

import UIKit

open class BOLL {
    required public init() {}
    
    var up_boll: Double = 0
    var mid_boll: Double = 0
    var dn_boll: Double = 0
    
    private static func calculateBOLL(_ data: inout [KLineData]) {
        
    }
}

extension BOLL: KLIndicator {
    public static var style: KLStyle = KLStyle.default
    
    public func calculate(_ data: inout [Any]) {
        
    }
}
