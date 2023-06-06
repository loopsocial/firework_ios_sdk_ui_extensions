//
//  Bundle+AppLanguage.swift
//  
//  Created by linjie jiang on 2023/2/7.
//

import Foundation
import FireworkVideo

extension Bundle {
    static func swizzleBundleMethodsForAppLanguage() {
        Swizzle.swizzleSelector(
            cls: self,
            originalSelector: #selector(Bundle.localizedString(forKey:value:table:)),
            customSelector: #selector(Bundle.fw_localizedString(forKey:value:table:)))
    }

    @objc func fw_localizedString(
        forKey key: String,
        value: String?,
        table tableName: String?
    ) -> String {
        if let language = AppLanguageManager.shared.appLanguage,
           let languageCode = AppLanguageManager.shared.appLanguageCode,
           Bundle(for: FireworkVideoSDK.self) == self {
            let iOSSDKBundle = Bundle(for: FireworkVideoSDK.self)
            var languageBundlePath: String?
            let defaultLanguageBundlePath = iOSSDKBundle.path(forResource: "Base", ofType: "lproj")
            if let path = iOSSDKBundle.path(forResource: language, ofType: "lproj") {
                languageBundlePath = path
            } else if let path = iOSSDKBundle.path(forResource: languageCode, ofType: "lproj") {
                languageBundlePath = path
            } else {
                let targeLanguageList = iOSSDKBundle.localizations.filter { item in
                    return item != "Base"
                }
                if let targeLanguage = targeLanguageList.first(where: { item in
                    let targeLanguageCode = LanguageUtil.getLanguageCode(item)
                    return languageCode == targeLanguageCode
                }) {
                    languageBundlePath = iOSSDKBundle.path(forResource: targeLanguage, ofType: "lproj")
                }
            }

            if let resultLanguageBundlePath = languageBundlePath ?? defaultLanguageBundlePath,
               let resultLanguageBundle = Bundle(path: resultLanguageBundlePath) {
                let localizedString = resultLanguageBundle.fw_localizedString(forKey: key, value: value, table: tableName)
                var keyNotFound = false
                if (value ?? "").isEmpty && localizedString == key {
                    keyNotFound = true
                } else if (value ?? "").count > 0 && localizedString == value {
                    keyNotFound = true
                }
                if keyNotFound, resultLanguageBundlePath != defaultLanguageBundlePath {
                    let defaultLanguageBundle = Bundle(path: defaultLanguageBundlePath ?? "")
                    return defaultLanguageBundle?.fw_localizedString(forKey: key, value: value, table: tableName) ?? localizedString
                } else {
                    return localizedString
                }
            } else {
                return self.fw_localizedString(forKey: key, value: value, table: tableName)
            }
        } else {
            return self.fw_localizedString(forKey: key, value: value, table: tableName)
        }
    }
}
