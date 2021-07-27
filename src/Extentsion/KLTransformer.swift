//
//  KLTransformer.swift
//  KLine
//
//  Created by pikacode on 2021/7/27.
//

import UIKit
import Charts

class KLTransformer: Transformer {
    @objc open override var pixelToValueMatrix: CGAffineTransform
    {
        let v = valueToPixelMatrix
        let arr = [(v.a, v.b), (v.a, v.c), (v.b, v.d), (v.c, v.d)]
        if arr.contains(where: { $0.0 == 0 && $0.1 == 0 }) {
            return v
        } else {
            return valueToPixelMatrix.inverted()
        }
    }
}
