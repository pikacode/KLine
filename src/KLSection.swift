//
//  KLSection.swift
//  KLine
//
//  Created by pikacode on 2021/6/8.
//

import UIKit

open class KLSection {

    public var types: [KLineType] = [.candle]

    public var height: CGFloat = 100

    public init(_ types: [KLineType] = [.candle], _ height: CGFloat = 100) {
        self.types = types
        self.height = height
    }

}
