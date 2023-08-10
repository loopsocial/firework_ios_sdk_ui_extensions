//
//  UIView+AppLanguage.swift
//
//  Created by linjie jiang on 2023/3/11.
//

import UIKit
import FireworkVideo
import AVFoundation

extension UIView {
    static func swizzleViewMethodsForAppLanguage() {
        Swizzle.swizzleSelector(
            cls: self,
            originalSelector: #selector(UIView.init(frame:)),
            customSelector: #selector(UIView.fw_init(frame:))
        )
        Swizzle.swizzleSelector(
            cls: self,
            originalSelector: #selector(UIView.awakeFromNib),
            customSelector: #selector(UIView.fw_viewAwakeFromNib)
        )
        Swizzle.swizzleSelector(
            cls: self,
            originalSelector: #selector(getter: UIView.semanticContentAttribute),
            customSelector: #selector(UIView.fw_semanticContentAttribute)
        )
    }

    @objc func fw_init(frame: CGRect) -> UIView {
        let view = self.fw_init(frame: frame)
        updateViewTypeIfNeeded(view)

        return view
    }

    @objc func fw_viewAwakeFromNib() {
        self.fw_viewAwakeFromNib()
        updateViewTypeIfNeeded(self)
    }

    @objc func fw_semanticContentAttribute() -> UISemanticContentAttribute {
        if self.isIOSSDKView, AppLanguageManager.shared.shouldHorizontalFlip {
            return .forceLeftToRight
        }

        return fw_semanticContentAttribute()
    }

    private func updateViewTypeIfNeeded(_ view: UIView) {
        if view is FireworkPlayerView, AppLanguageManager.shared.shouldHorizontalFlip {
            view.viewType = .normal
        }

        DispatchQueue.main.async {
            if view.layer.sublayers?.first(where: { layer in
                layer is AVPlayerLayer
            }) != nil, AppLanguageManager.shared.shouldHorizontalFlip {
                view.viewType = .normal
            }
        }
    }
}
