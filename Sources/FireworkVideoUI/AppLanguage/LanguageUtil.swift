//
//  LanguageUtil.swift
//  
//  Created by linjie jiang on 2023/2/9.
//

import Foundation

class LanguageUtil {
   static func getLanguageCode(_ language: String) -> String? {
        guard language.count > 0 else {
            return nil
        }

        var languageCode = ""
        #if compiler(>=5.7)
        if #available(iOS 16, *) {
            languageCode = Locale(identifier: language).language.languageCode?.identifier ?? ""
        } else {
            languageCode = Locale(identifier: language).languageCode ?? ""
        }
        #else
        languageCode = Locale(identifier: language).languageCode ?? ""
        #endif
        return languageCode.lowercased()
    }

    static func isValidLanguage(_ language: String?) -> Bool {
        guard let language = language else {
            return false
        }

        guard language.count > 0 else {
            return false
        }

        let languageWithUnderline = language.replacingOccurrences(of: "-", with: "_")

        let availableIdentifiers = Locale.availableIdentifiers

        return availableIdentifiers.contains(language) || availableIdentifiers.contains(languageWithUnderline)
    }
}
