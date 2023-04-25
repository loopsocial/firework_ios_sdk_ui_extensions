//
//  UIView+Swizzle.swift
//
//  Created by linjie jiang on 2023/3/11.
//

import UIKit
import FireworkVideo

extension UIView {
    static func swizzleViewMethodsForAppLanguage() {
        SwizzleUtil.swizzleSelector(
            cls: self,
            originalSelector: #selector(UIView.init(frame:)),
            customSelector: #selector(UIView.fw_init(frame:))
        )
        SwizzleUtil.swizzleSelector(
            cls: self,
            originalSelector: #selector(UIView.awakeFromNib),
            customSelector: #selector(UIView.fw_viewAwakeFromNib)
        )
    }

    @objc func fw_init(frame: CGRect) -> UIView {
        let view = self.fw_init(frame: frame)
        if view is FireworkPlayerView {
            view.viewType = .normal
        }
        return view
    }

    @objc func fw_viewAwakeFromNib() {
        self.fw_viewAwakeFromNib()
        if self is FireworkPlayerView, AppLanguageManager.shared.shouldHorizontalFlip {
            self.viewType = .normal
        }
    }
}
