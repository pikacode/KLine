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

    @IBAction func mainIndicatorAction1(_ sender: Any) { changeMainIndicator(0) }
    @IBAction func mainIndicatorAction2(_ sender: Any) { changeMainIndicator(1) }
    @IBAction func mainIndicatorAction3(_ sender: Any)  { changeMainIndicator(2) }
    func changeMainIndicator(_ index: Int) {

    }

    @IBAction func otherIndicatorAction1(_ sender: Any) { changeOtherIndicator(0) }
    @IBAction func otherIndicatorAction2(_ sender: Any) { changeOtherIndicator(1) }
    @IBAction func otherIndicatorAction3(_ sender: Any) { changeOtherIndicator(2) }
    @IBAction func otherIndicatorAction4(_ sender: Any) { changeOtherIndicator(3) }
    func changeOtherIndicator(_ index: Int) {

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
