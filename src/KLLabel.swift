//
//  KLLabel.swift
//  KLine
//
//  Created by pikacode on 2021/6/18.
//

import UIKit

public class KLLabel {

    public static var color = UIColor.white.alpha(0.6)
    public static var font = UIFont.systemFont(ofSize: 10)

    public static var bgColor = UIColor.clear
    public static var position = KLPosition.left(.zero)

    public static var dashLengths: [CGFloat] = [4, 1]
    public static var dashPhase = CGFloat.zero

    public var text = ""
    public var font = KLLabel.font
    public var color = KLLabel.color
    public var bgColor = KLLabel.bgColor
    public var position = KLLabel.position
    public var dashLengths = KLLabel.dashLengths
    public var dashPhase = KLLabel.dashPhase

    init(_ label: KLLabel? = nil) {
        if let label = label {
            text = ""
            font = label.font
            color = label.color
            bgColor = label.bgColor
            position = label.position
            dashLengths = label.dashLengths
            dashPhase = label.dashPhase
        }
    }
}
