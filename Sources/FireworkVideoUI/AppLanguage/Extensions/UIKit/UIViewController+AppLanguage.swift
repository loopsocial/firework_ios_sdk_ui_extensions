//
//  UIViewController+AppLanguage.swift
//
//  Created by linjie jiang on 2023/2/21.
//

import UIKit
import FireworkVideo

extension UIViewController {
    static func swizzleViewControllerMethodsForAppLanguage() {
        Swizzle.swizzleSelector(
            cls: self,
            originalSelector: #selector(UIViewController.present(_:animated:completion:)),
            customSelector: #selector(UIViewController.fw_present(_:animated:completion:))
        )

        Swizzle.swizzleSelector(
            cls: self,
            originalSelector: #selector(UIViewController.viewDidLoad),
            customSelector: #selector(UIViewController.fw_viewDidLoad)
        )
    }

    @objc func fw_present(
        _ viewControllerToPresent: UIViewController,
        animated flag: Bool,
        completion: (() -> Void)? = nil
    ) {
        let iOSSDKBundle = Bundle(for: FireworkVideoSDK.self)
        let viewControllerToPresentBundle = Bundle(for: type(of: viewControllerToPresent))
        if AppLanguageManager.shared.shouldHorizontalFlip,
           viewControllerToPresentBundle == iOSSDKBundle {
            viewControllerToPresent.view.viewType = .flip
        }
        fw_present(viewControllerToPresent, animated: flag, completion: completion)
    }

    @objc func fw_viewDidLoad() {
        fw_viewDidLoad()
        if self is StoryBlockViewController
            || self is VideoFeedViewController {
            self.view.viewType = .flip
        }
    }
}
