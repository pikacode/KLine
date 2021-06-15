//
//  MA.swift
//  KLine
//
//  Created by pikacode on 2021/6/15.
//

import UIKit

open class MA: KLIndicator {

    public static var style: KLStyle = KLStyle.default

    public static var days = [7, 25, 60]

    var data: [Int: Double] = [7: 0, 25: 0, 60: 0]

    public static func calculate(_ data: inout [KLineData]) {
        days.forEach{
            self.calculateMA(&data, day: $0)
        }
    }

    static func calculateMA(_ data: inout [KLineData], day: Int) {
//        for i in (day-1)..<(data.count-1) {
//            if let last1 = data[(i-1)~], var ma = last1.ma, let lastn = data[(i-day)~] {
//                var sum = ma * day - lastn.close
//            } else {
//
//            }
//        }
    }

}


