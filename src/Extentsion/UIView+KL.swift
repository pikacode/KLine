//
//  UIView+KL.swift
//  KLine
//
//  Created by pikacode on 2021/6/22.
//

import Foundation

extension UIView {

    // block中引用自己可能产生泄露
    private static var blockKey = "blockKey"
    private var block: (() -> Void)? {
        get { return objc_getAssociatedObject(self, &UIView.blockKey) as? () -> Void }
        set { objc_setAssociatedObject(self, &UIView.blockKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }

    public func addTap(_ aBlock: @escaping () -> Void) {
        block = aBlock
        isUserInteractionEnabled = true
        if let button = self as? UIButton {
            button.removeTarget(self, action: nil, for: .touchUpInside)
            button.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
        } else {
            gestureRecognizers?.forEach { [weak self] in
                if $0 is UITapGestureRecognizer {
                    self?.removeGestureRecognizer($0)
                }
            }
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
            addGestureRecognizer(tap)
        }
    }

    @objc func tapAction() {
        block?()
    }

}
