//
//  ChartSettingsView.swift
//  demo
//
//  Created by pikacode on 2021/6/22.
//

import UIKit
import Charts

class ChartSettingsView: UIView {

    @IBOutlet weak var contentTrailing: NSLayoutConstraint!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var back: UIImageView!
    @IBOutlet weak var heightRectLeading: NSLayoutConstraint!
    @IBOutlet var mainButtons: [UIButton]!
    @IBOutlet var otherButtons: [UIButton]!
    @IBOutlet var switchs: [UISwitch]!

    var settings: ChartSettings { return ChartSettings.shared }

    @IBAction func heightAction(_ sender: UIButton) {
        heightRectLeading.constant = [0, 121, 242][sender.tag]
        settings.mainHeight = [182, 282, 382][sender.tag]
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }

    //主图指标
    @IBAction func mainIndicatorAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            sender.superview?.bringSubviewToFront(sender)
        } else {
            sender.superview?.sendSubviewToBack(sender)
        }
        var s = settings.mainIndicators[sender.tag]
        s.1 = sender.isSelected
        settings.mainIndicators[sender.tag] = s
    }

    //副图指标
    @IBAction func otherIndicatorAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            sender.superview?.bringSubviewToFront(sender)
        } else {
            sender.superview?.sendSubviewToBack(sender)
        }
        var s = settings.otherIndicators[sender.tag]
        s.1 = sender.isSelected
        settings.otherIndicators[sender.tag] = s
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
            if self.mainButtons.count >= $0.offset+1 {
                self.mainButtons[$0.offset].isSelected = $0.element.on
            }
        }

        settings.otherIndicators.enumerated().forEach{
            self.otherButtons[$0.offset].isSelected = $0.element.on
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
