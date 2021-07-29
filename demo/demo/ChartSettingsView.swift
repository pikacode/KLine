//
//  ChartSettingsView.swift
//  demo
//
//  Created by pikacode on 2021/6/22.
//

import UIKit
import Charts
import KLine

class ChartSettingsView: UIView {

    @IBOutlet weak var contentTrailing: NSLayoutConstraint!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var back: UIImageView!
    @IBOutlet weak var heightRectLeading: NSLayoutConstraint!
    @IBOutlet var indicatorButtons: [UIButton]!
    @IBOutlet var switchs: [UISwitch]!

    var settings: ChartSettings { return ChartSettings.shared }

    @IBAction func heightAction(_ sender: UIButton) {
        heightRectLeading.constant = [0, 121, 242][sender.tag]
        settings.mainHeight = settings.mainHeights[sender.tag]
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }

    @IBAction func indicatorAction(_ sender: UIButton) {
        //主图指标先全改为false
        if indicatorButtons[0...2].contains(sender) {
            indicatorButtons[0...2].forEach{
                if $0 == sender {
                    $0.isSelected.toggle()
                } else {
                    $0.isSelected = false
                }
            }
        } else {
            sender.isSelected.toggle()
        }

        if sender.isSelected {
            sender.superview?.bringSubviewToFront(sender)
        } else {
            sender.superview?.sendSubviewToBack(sender)
        }

        let selecteds1 = Array(indicatorButtons.map{ $0.isSelected }[0...2])
        let selecteds2 = Array(indicatorButtons.map{ $0.isSelected }[3...6])
        var mains = ChartSettings.shared.mainIndicators
        mains.enumerated().forEach{
            if let on = selecteds1[$0.offset~] {
                mains[$0.offset] = ($0.element.indicator, on)
            }
        }
        ChartSettings.shared.mainIndicators = mains

        var others = ChartSettings.shared.otherIndicators
        others.enumerated().forEach{
            let on = selecteds2[$0.offset]
            others[$0.offset] = ($0.element.indicator, on)
        }
        ChartSettings.shared.otherIndicators = others
    }

    //线
    @IBAction func switchAction(_ sender: UISwitch) {
        var p = settings.priceLines[sender.tag]
        p.enabled.toggle()
        settings.priceLines[sender.tag] = p
    }

    override func awakeFromNib() {
        contentTrailing.constant = -280
        bgView.alpha = 0

        back.addTap { [weak self] in
            self?.dismiss()
        }
        bgView.addTap { [weak self] in
            self?.dismiss()
        }

        if let index = [182, 282, 382].firstIndex(where: { $0 == settings.mainHeight }) {
            heightRectLeading.constant = [0, 121, 242][index]
        }

        settings.mainIndicators.enumerated().forEach{
            let b = self.indicatorButtons[$0.offset~]
            b?.isSelected = $0.element.on
            if $0.element.on, let b = b {
                b.superview?.bringSubviewToFront(b)
            }
        }

        settings.otherIndicators.enumerated().forEach{
            let b = self.indicatorButtons[(3+$0.offset)~]
            b?.isSelected = $0.element.on
            if $0.element.on, let b = b {
                b.superview?.bringSubviewToFront(b)
            }
        }

        settings.priceLines.enumerated().forEach{
            self.switchs[$0.offset].isOn = $0.element.enabled
        }
    }

    func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
        frame = UIScreen.main.bounds
        self.superview?.layoutIfNeeded()

        UIView.animate(withDuration: 0.2) {
            self.bgView.alpha = 1
            self.contentTrailing.constant = 0
            self.superview?.layoutIfNeeded()
        }
    }

    func dismiss() {
        UIView.animate(withDuration: 0.2) {
            self.bgView.alpha = 0
            self.contentTrailing.constant = -280
            self.superview?.layoutIfNeeded()
        } completion: { (_) in
            self.removeFromSuperview()
        }
    }

}
