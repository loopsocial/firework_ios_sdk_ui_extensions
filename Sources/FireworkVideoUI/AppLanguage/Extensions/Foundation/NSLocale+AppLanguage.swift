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
        Swizzle.swizzleClassSelector(
            cls: self,
            originalSelector: #selector(getter: NSLocale.autoupdatingCurrent),
            customSelector: #selector(NSLocale.fw_autoupdatingCurrent))
        Swizzle.swizzleClassSelector(
            cls: self,
            originalSelector: #selector(getter: NSLocale.preferredLanguages),
            customSelector: #selector(NSLocale.fw_preferredLanguages))
    }

    @objc class func fw_current() -> Locale {
        if let language = AppLanguageManager.shared.appLanguage {
            return Locale(identifier: language)
        }

        return fw_current()
    }

    @objc class func fw_autoupdatingCurrent() -> Locale {
        if let language = AppLanguageManager.shared.appLanguage {
            return Locale(identifier: language)
        }

        return fw_autoupdatingCurrent()
    }

    @objc class func fw_preferredLanguages() -> [String] {
        let languages = fw_preferredLanguages()
        if let language = AppLanguageManager.shared.appLanguage {
            return [language] + languages
        }

        return languages
    }
}
