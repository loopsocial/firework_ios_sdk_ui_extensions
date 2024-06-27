//
//  UITextView+AppLanguage.swift
//
//  Created by linjie jiang on 2023/2/23.
//

import UIKit

extension UITextView {
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

    static func swizzleTextViewMethodsForAppLanguage() {
        Swizzle.swizzleSelector(cls: self,
                                    originalSelector: #selector(setter: UITextView.textAlignment),
                                    customSelector: #selector(UITextView.fw_setTextViewTextAlignment(_:)))
        Swizzle.swizzleSelector(cls: self,
                                    originalSelector: #selector(UITextView.didMoveToWindow),
                                    customSelector: #selector(UITextView.fw_textViewDidMoveToWindow))
    }

    @objc func fw_setTextViewTextAlignment(_ textAlignment: NSTextAlignment) {
        addReloadClosure(key: "alignment") { [weak self] in
            guard let self = self else {
                return
            }

            self.fw_setTextViewTextAlignment(self.calculatedTextAlignment(textAlignment))
        }
    }

    @objc func fw_textViewDidMoveToWindow() {
        fw_textViewDidMoveToWindow()
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
           layoutDirection != .unsupported {
            return true
        }

        return false
    }
}
