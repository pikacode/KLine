//
//  KLMarkerView.swift
//  KLine
//
//  Created by aax1 on 2021/7/12.
//

import UIKit
import UIKit
import Charts
class KLMarkerView: UIView {

    var markerView: KLMarker!
    var labelArr: [UILabel] = []
    
    
    func initUI() {
//        labelArr = [openLabel, closeLabel, highLabel, lowLabel, volLabel, changeQuotaLabel, changeRateLabel]
        let titleArr = ["开","收","高","低","量","涨跌额","涨跌幅"]
        
        markerView = KLMarker.init(frame: CGRect.init(x: 0, y: 0, width: 130, height: 173))
        
        markerView.backgroundColor = UIColor.init(red: 38 / 255, green: 38 / 255, blue: 38 / 255, alpha: 0.8)
        markerView.layer.borderWidth = 0.5
        markerView.layer.borderColor = UIColor.init(red: 151 / 255, green: 151 / 255, blue: 151 / 255, alpha: 0.4).cgColor

        for index in 0 ..< titleArr.count {
        let tView = UIView.init()

            let height = markerView.bounds.size.height / CGFloat(titleArr.count)
            let top = CGFloat(height) * CGFloat(index)

            tView.frame = CGRect.init(x: 0, y: top, width: markerView.bounds.size.width, height: height)
            markerView.addSubview(tView)
            tView.backgroundColor = .clear
            
            addCell(title: titleArr[index],  bgView: tView)
            
        }
    }
    
    
    func addCell(title: String, bgView: UIView) {
        
        let label = addLabel(title: title)
        let W = bgView.bounds.size.width - 12.0
        let H = bgView.bounds.size.height
        
        label.frame = CGRect.init(x: 6, y: 0, width: W, height: H)
        label.textAlignment = .left
        bgView.addSubview(label)

                
        let valueLabel = addLabel(title: "35420.12", valueLabel: true)
        valueLabel.textAlignment = .right
        bgView.addSubview(valueLabel)
        valueLabel.frame = CGRect.init(x: 6, y: 0, width: W, height: H)
        valueLabel.textAlignment = .right
        labelArr.append(valueLabel)
    }
    
    func addLabel(title: String, valueLabel: Bool = false) -> UILabel {
        let label = UILabel.init()
        label.text = title
        label.textColor = valueLabel ? .white : UIColor.init(r: 153, g: 153, b: 153)
        label.font = .systemFont(ofSize: 12)
        return label
    }
    
    func updateValue(model: CandleChartDataEntry) {
        
        
        labelArr[0].text = "\(model.open)"
        labelArr[1].text = "\(model.close)"
        labelArr[2].text = "\(model.high)"
        labelArr[3].text = "\(model.low)"

//        volLabel?.text = "\(model.open)"
//        changeRateLabel?.text = "\(model.open)"
//        changeQuotaLabel?.text = "\(model.open)"

        
    }

}
