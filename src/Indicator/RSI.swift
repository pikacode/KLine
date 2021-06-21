//
//  RSI.swift
//  KLine
//
//  Created by aax1 on 2021/6/18.
//

import UIKit

open class RSI: KLIndicator {
    public static var style: KLStyle = KLStyle.default
    public static var days = [6, 12, 24]
    
    //RSI指标参数
    var up_avg_6: Double   = 0
    var up_avg_12: Double  = 0
    var up_avg_24: Double  = 0
    var dn_avg_6: Double   = 0
    var dn_avg_12: Double  = 0
    var dn_avg_24: Double  = 0
    var rsi6: Double       = 0
    var rsi12: Double      = 0
    var rsi24: Double      = 0
    
    
    public static func calculate(_ data: inout [KLineData]) {
        
    }
    
    private static func calculateRSI(_ data: inout [KLineData]) {
        if data.count < 5 {
            return
        }
        for i in 0 ..< data.count {
            let model = data[i]
            if i == 0 {
                
            }else{
                
            }
            
        }
    }
    
//    static func ks_calculateRS(index: Int, datas: [KLineData]) {
//        
//        let tempModel   = datas[index]
//        let lastModel   = datas[index - 1]
//        let minAvg = 0
//        let midAvg = 1
//        let maxAvg = 2
//        
//            
//        let diff        = tempModel.close - lastModel.close
//        let up: Double = fmax(0.0, diff)
//        let dn: Double = abs(fmin(0.0, diff))
//
//        if index == 1 {
//            tempModel.up_avg_6  = up / minAvg
//            tempModel.up_avg_12 = up / midAvg
//            tempModel.up_avg_24 = up / maxAvg
//
//            tempModel.dn_avg_6  = dn / minAvg
//            tempModel.dn_avg_12 = dn / midAvg
//            tempModel.dn_avg_24 = dn / maxAvg
//        } else {
//            tempModel.up_avg_6  = (up / minAvg) + ((lastModel.up_avg_6 * (minAvg - 1)) / minAvg)
//            tempModel.up_avg_12 = (up / midAvg) + ((lastModel.up_avg_12 * (midAvg - 1)) / midAvg)
//            tempModel.up_avg_24 = (up / maxAvg) + ((lastModel.up_avg_24 * (maxAvg - 1)) / maxAvg)
//
//            tempModel.dn_avg_6  = (dn / minAvg) + ((lastModel.dn_avg_6 * (minAvg - 1)) / minAvg)
//            tempModel.dn_avg_12 = (dn / midAvg) + ((lastModel.dn_avg_12 * (midAvg - 1)) / midAvg)
//            tempModel.dn_avg_24 = (dn / maxAvg) + ((lastModel.dn_avg_24 * (maxAvg - 1)) / maxAvg)
//        }
//    }

    

}
