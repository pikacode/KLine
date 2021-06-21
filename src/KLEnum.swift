//
//  KLEnum.swift
//  KLine
//
//  Created by pikacode on 2021/6/18.
//

import UIKit

/// - position = top ，offset =  (origin.x + size.width) / 2), origin.y， 是矩形上边中点
/// - position = left ，offset  = origin.x, (origin.y + size.height) / 2，是矩形左边中点，以此类推
public enum KLPosition {
    case top(_ offset: CGPoint)
    case left(_ offset: CGPoint)
    case right(_ offset: CGPoint)
    case bottom(_ offset: CGPoint)
}

public enum KLDirection {
    case horizontal
    case vertical
}

public enum KLOrderDirection {
    case buy
    case sell
}

