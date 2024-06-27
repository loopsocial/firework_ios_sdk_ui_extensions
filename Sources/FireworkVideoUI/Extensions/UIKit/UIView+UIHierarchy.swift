//
//  UIView+UIHierarchy.swift
//
//  Created by Jeff Zheng on 2021/12/22.
//

import UIKit
import FireworkVideo

public extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }

        return nil
    }

    var isIOSSDKView: Bool {
        guard self.window != nil else {
            return false
        }

        var targetView: UIView? = self
        var targetParentVC = targetView?.parentViewController
        while targetParentVC != nil {
            let targetParentVCTypeName = String(reflecting: type(of: targetParentVC!))
            if targetParentVCTypeName.hasPrefix("SwiftUI.") {
                targetView = targetView?.superview
                targetParentVC = targetView?.parentViewController
            } else {
                break
            }
        }

        guard let parentVC = targetParentVC else {
            return false
        }
        let iOSSDKBundle = Bundle(for: FireworkVideoSDK.self)

        if iOSSDKBundle == Bundle(for: type(of: parentVC)) {
            return true
        }

        var ancestorVC = parentVC.parent
        while ancestorVC != nil {
            if iOSSDKBundle == Bundle(for: type(of: ancestorVC!)) {
                return true
            }
            ancestorVC = ancestorVC!.parent
        }

        return false
    }
}
