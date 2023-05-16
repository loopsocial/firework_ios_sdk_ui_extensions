//
//  UIWindow+AppLanguage.swift
//
//  Created by linjie jiang on 2023/2/24.
//

import UIKit
import FireworkVideo

extension UIWindow {
    static func swizzleWindowMethodsForAppLanguage() {
        Swizzle.swizzleSelector(cls: self,
                                      originalSelector: #selector(setter: UIWindow.rootViewController),
                                      customSelector: #selector(UIWindow.fw_setRootViewController(_:)))
    }

    @objc func fw_setRootViewController(_ rootViewController: UIViewController?) {
        fw_setRootViewController(rootViewController)
        let iOSSDKBundle = Bundle(for: FireworkVideoSDK.self)
        if AppLanguageManager.shared.shouldHorizontalFlip,
           let viewController = rootViewController,
           Bundle(for: type(of: viewController)) == iOSSDKBundle {
            viewController.view.viewType = .flip
        }
    }
}
