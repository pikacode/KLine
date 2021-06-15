//
//  KLSection.swift
//  KLine
//
//  Created by pikacode on 2021/6/8.
//

import UIKit

open class KLSection {

    public var indicators: [KLIndicator.Type] = [MA.self]

    public var height: CGFloat = 100

    public init(_ indicators: [KLIndicator.Type], _ height: CGFloat = 100) {
        self.indicators = indicators
        self.height = height
    }

}
