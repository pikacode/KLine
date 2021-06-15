//
//  KLSection.swift
//  KLine
//
//  Created by pikacode on 2021/6/8.
//

import UIKit

open class KLSection {

    public var indicators: [KLIndicator.Type] = [MA.self]

    public init(_ indicators: [KLIndicator.Type]) {
        self.indicators = indicators
    }

}
