//
//  KLMarkerView.swift
//  KLine
//
//  Created by aax1 on 2021/7/12.
//

import UIKit
import Charts
import KLine
class KLMarkerView: UIView {

//    var markerView: KLMarker!
    var labelArr: [UILabel] = []
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initUI() {
        let titleArr = ["开","收","高","低","量","涨跌额","涨跌幅"]
        
        self.backgroundColor = UIColor.init(red: 38 / 255, green: 38 / 255, blue: 38 / 255, alpha: 0.8)
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.init(red: 151 / 255, green: 151 / 255, blue: 151 / 255, alpha: 0.4).cgColor

        for index in 0 ..< titleArr.count {
        let tView = UIView.init()

            let height = self.bounds.size.height / CGFloat(titleArr.count)
            let top = CGFloat(height) * CGFloat(index)

            tView.frame = CGRect.init(x: 0, y: top, width: self.bounds.size.width, height: height)
            self.addSubview(tView)
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
        label.textColor = valueLabel ? .white : .init(red: 153 / 255, green: 153 / 255, blue: 153 / 255, alpha: 1)
        label.font = .systemFont(ofSize: 12)
        return label
    }
    
    func updateValue(model: KLineData) {
        
        labelArr[0].text = String.init(format: "%.2f", model.open)
        labelArr[1].text = String.init(format: "%.2f", model.close)
        labelArr[2].text = String.init(format: "%.2f", model.high)
        labelArr[3].text = String.init(format: "%.2f", model.low)
        labelArr[4].text = String.init(format: "%.2f", model.vol)
        labelArr[5].text = String.init(format: "%.2f", model.vol)
        labelArr[6].text = String.init(format: "%.2f", model.vol)

        
    }

}
