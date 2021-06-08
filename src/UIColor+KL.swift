//
//  UIColor.swift
//  KLine
//
//  Created by pikacode on 2021/6/1.
//

import UIKit

extension UIColor {

    static let c0188ff = UIColor(hex: 0x0188ff)
    static let c0e0e0e = UIColor(hex: 0x0e0e0e)

    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }

    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(hex & 0x0000FF) / 255.0,
                  alpha: alpha)
    }

    func alpha(_ a: CGFloat) -> UIColor { return withAlphaComponent(a) }

    static func color(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha))
    }

    static func color(hex hexStr: String, alpha: CGFloat = 1.0) -> UIColor {
        var hex: String = hexStr
        if hex.hasPrefix("#") {
            hex.remove(at: hex.startIndex)
        }

        let redStart = hex.index(hex.startIndex, offsetBy: 0)
        let redEnd   = hex.index(hex.startIndex, offsetBy: 2)
        let redStr: String = String(hex[redStart..<redEnd])

        let greenStart = hex.index(hex.startIndex, offsetBy: 2)
        let greenEnd   = hex.index(hex.startIndex, offsetBy: 4)
        let greenStr: String = String(hex[greenStart..<greenEnd])

        let blueStart = hex.index(hex.startIndex, offsetBy: 4)
        let blueEnd   = hex.index(hex.startIndex, offsetBy: 6)
        let blueStr: String = String(hex[blueStart..<blueEnd])

        var red: UInt32 = 0, green: UInt32 = 0, blue: UInt32 = 0
        Scanner(string: redStr).scanHexInt32(&red)
        Scanner(string: greenStr).scanHexInt32(&green)
        Scanner(string: blueStr).scanHexInt32(&blue)
        return UIColor.color(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: alpha)
    }

}
