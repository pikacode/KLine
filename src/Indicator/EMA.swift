//
//  EMA.swift
//  KLine
//
//  Created by aax1 on 2021/6/17.
//

import UIKit

open class EMA: KLIndicator {
    
    public static var style: KLStyle = KLStyle.default
    
    public static var days = [12, 25, 26]
    
    var data: [Int: Double] = EMA.days.reduce(into: [Int: Double]()) { $0[$1] = 0 }
    
    public static func calculate(_ data: inout [KLineData]) {
        days.forEach{
            self.calculateEMA(&data, day: $0)
        }
    }
    
    static func calculateEMA(_ data: inout [KLineData], day: Int) {
        
        if day > data.count {
            return
        }
        for i in (day-1)..<(data.count - 1) {
            let model = data[i]
            let ema = data[i].ema ?? EMA()
            if i == 0 {
                //第一天的ema12 是收盘价
                ema.data[day] =  model.close
            }else{
                if  let lastEmaDay = model.ema?.data[day - 1] {
                    ema.data[day] = Double((2 / (day + 1))) * (model.close - lastEmaDay) + lastEmaDay
                }
            }
            data[i].ema = ema
        }
        
        
    }
    
    
    
    
    
}
