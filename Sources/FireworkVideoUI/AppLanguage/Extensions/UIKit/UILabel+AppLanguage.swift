//
//  UILabel+AppLanguage.swift
//
//  Created by linjie jiang on 2023/2/22.
//

import UIKit

extension UILabel {
    private struct AssociatedKeys {
        static var hasCalculatedTextAlignment: UInt8 = 0
    }

    private var hasCalculatedTextAlignment: Bool {
        get {
            let result = objc_getAssociatedObject(self, &AssociatedKeys.hasCalculatedTextAlignment) as? Bool
            return result ?? false
        }

        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.hasCalculatedTextAlignment,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }

    static func swizzleLabelMethodsForAppLanguage() {
        Swizzle.swizzleSelector(cls: self,
                                    originalSelector: #selector(setter: UILabel.textAlignment),
                                    customSelector: #selector(UILabel.fw_setLabelTextAlignment(_:)))
        Swizzle.swizzleSelector(cls: self,
                                    originalSelector: #selector(UILabel.didMoveToWindow),
                                    customSelector: #selector(UILabel.fw_labelDidMoveToWindow))
    }

    @objc func fw_setLabelTextAlignment(_ textAlignment: NSTextAlignment) {
        addReloadClosure(key: "alignment") { [weak self] in
            guard let self = self else {
                return
            }

            self.fw_setLabelTextAlignment(self.calculatedTextAlignment(textAlignment))
        }
    }

    @objc func fw_labelDidMoveToWindow() {
        fw_labelDidMoveToWindow()
        if self.window == nil {
            self.hasCalculatedTextAlignment = false
            return
        }
        if shouldCalculateTextAlignment(),
           !self.hasCalculatedTextAlignment,
           self.isIOSSDKView {
            self.textAlignment = self.textAlignment
        }
    }

    private func calculatedTextAlignment(_ textAlignment: NSTextAlignment) -> NSTextAlignment {
        if shouldCalculateTextAlignment(),
           let layoutDirection = AppLanguageManager.shared.appLanguageLayoutDirection {
            self.hasCalculatedTextAlignment = true
            if layoutDirection == .rtl {
                if textAlignment == .center {
                    return textAlignment
                } else if textAlignment == .right {
                    return .left
                } else {
                    return .right
                }
            } else if layoutDirection == .ltr {
                return .left
            }
        } else {
            return textAlignment
        }
        return textAlignment
    }

    private func shouldCalculateTextAlignment() -> Bool {
        if AppLanguageManager.shared.shouldHorizontalFlip,
           self.isIOSSDKView,
           let layoutDirection = AppLanguageManager.shared.appLanguageLayoutDirection,
           layoutDirection != .unsupported,
           shouldUseCalculatedTextAlignment() {
            return true
        }

        return false
    }
}
