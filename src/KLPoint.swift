//
//  KLPoint.swift
//  KLine
//
//  Created by pikacode on 2021/6/18.
//

import UIKit

extension CGPoint: KLPoint {}

public protocol KLPoint {
    var x: CGFloat { get set }
    var y: CGFloat { get set }
}
