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

    let settings = ChartSettings.shared


    @IBAction func heightAction1(_ sender: Any) { changeHeight(0) }
    @IBAction func heightAction2(_ sender: Any) { changeHeight(1) }
    @IBAction func heightAction3(_ sender: Any) { changeHeight(2) }
    func changeHeight(_ index: Int) {
        heightRectLeading.constant = [0, 121, 242][index]
        settings.mainHeight = [182, 282, 382][index]
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
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
