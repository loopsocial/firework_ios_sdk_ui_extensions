//
//  UITextField+AppLanguage.swift
//
//  Created by linjie jiang on 2023/2/23.
//

import UIKit

extension UITextField {
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

    static func swizzleTextFieldMethodsForAppLanguage() {
        Swizzle.swizzleSelector(cls: self,
                                    originalSelector: #selector(setter: UITextField.textAlignment),
                                    customSelector: #selector(UITextField.fw_setTextFieldTextAlignment(_:)))
        Swizzle.swizzleSelector(cls: self,
                                    originalSelector: #selector(UITextField.didMoveToWindow),
                                    customSelector: #selector(UITextField.fw_textFieldDidMoveToWindow))
    }

    @objc func fw_setTextFieldTextAlignment(_ textAlignment: NSTextAlignment) {
        addReloadClosure(key: "alignment") { [weak self] in
            guard let self = self else {
                return
            }

            self.fw_setTextFieldTextAlignment(self.calculatedTextAlignment(textAlignment))
        }
    }

    @objc func fw_textFieldDidMoveToWindow() {
        fw_textFieldDidMoveToWindow()
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
