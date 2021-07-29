//
//  UIViewController+KL.swift
//  KLine
//
//  Created by pikacode on 2021/7/29.
//

import UIKit


extension UIViewController {

    static var current: UIViewController? {
        return UIViewController.currentViewController()
    }

    class func currentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return currentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return currentViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return currentViewController(base: presented)
        }
        return base
    }
}
