//
//  UIViewController+KL.swift
//  KLine
//
//  Created by pikacode on 2021/7/29.
//

import UIKit


extension UIViewController {

    static var kl_current: UIViewController? {
        return UIViewController.kl_currentViewController()
    }

    class func kl_currentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return kl_currentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return kl_currentViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return kl_currentViewController(base: presented)
        }
        return base
    }
}
