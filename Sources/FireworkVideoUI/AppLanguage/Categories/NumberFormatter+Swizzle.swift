//
//  NumberFormatter+Swizzle.swift
//  
//  Created by linjie jiang on 2023/2/20.
//

import Foundation

extension NumberFormatter {
    static func swizzleNumberFormatterMethodsForAppLanguage() {
        SwizzleUtil.swizzleSelector(
            cls: self,
            originalSelector: #selector(NumberFormatter.string(from:)),
            customSelector: #selector(NumberFormatter.fw_string(from:)))
    }

    @objc func fw_string(from number: NSNumber) -> String? {
        if let language = AppLanguageManager.shared.appLanguage,
           self.numberStyle == .currency {
            self.locale = Locale(identifier: language)
        }

        return fw_string(from: number)
    }
}
