//
//  Locale+AppLanguage.swift
//
//  Created by linjie jiang on 5/7/24.
//

import Foundation

extension NSLocale {
    static func swizzleNSLocaleMethodsForAppLanguage() {
        Swizzle.swizzleClassSelector(
            cls: self,
            originalSelector: #selector(getter: NSLocale.current),
            customSelector: #selector(NSLocale.fw_current))
    }

    @objc static func fw_current() -> Locale {
        if let language = AppLanguageManager.shared.appLanguage {
            return Locale(identifier: language)
        }

        return fw_current()
    }
}
