//
//  KLEnum.swift
//  KLine
//
//  Created by pikacode on 2021/6/18.
//

import UIKit

/// offset 偏移量
public enum KLPosition {
    case left(_ offset: CGPoint) //居左
    case right(_ offset: CGPoint) //居右
    case center(_ offset: CGPoint) //居中
}

public enum KLDirection {
    case horizontal
    case vertical
}

public enum KLOrderDirection {
    case buy
    case sell
}
