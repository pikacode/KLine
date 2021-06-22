//
//  KLLabel.swift
//  KLine
//
//  Created by pikacode on 2021/6/18.
//

import UIKit

public class KLLabel {

    public static var color = UIColor.black
    public static var font = UIFont.systemFont(ofSize: 10)

    public static var bgColor = UIColor.clear
    public static var position = KLPosition.left(.zero)

    public var text = ""
    public var font = KLLabel.font
    public var color = KLLabel.color
    public var bgColor = KLLabel.bgColor
    public var position = KLLabel.position
}
