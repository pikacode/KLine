//
//  KLIndicator.swift
//  KLine
//
//  Created by pikacode on 2021/6/15.
//

import UIKit

public protocol KLIndicator {
    static func calculate(_ data: inout [KLineData])

    static var style: KLStyle { get set }
}
