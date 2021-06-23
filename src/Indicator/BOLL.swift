//
//  BOLL.swift
//  KLine
//
//  Created by aax1 on 2021/6/23.
//

import UIKit

open class BOLL {
    required public init() {}
}


extension BOLL: KLIndicator{
    public static var style: KLStyle = KLStyle.default
    public func calculate(_ data: inout [Any]) {
        
    }
}
