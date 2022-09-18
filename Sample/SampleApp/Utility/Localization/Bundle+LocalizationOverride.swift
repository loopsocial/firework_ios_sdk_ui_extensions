//
//  Bundle+Localization.swift
//  SampleApp
//
//  Created by Andres Lara on 9/16/22.
//

import Foundation
import FireworkVideo

extension Bundle {
    static func swizzleLocalization() {
        let orginalSelector = #selector(localizedString(forKey:value:table:))
        guard let orginalMethod = class_getInstanceMethod(self, orginalSelector) else { return }

        let customSelector = #selector(customLocaLizedString(forKey:value:table:))
        guard let customMethod = class_getInstanceMethod(self, customSelector) else { return }

        if class_addMethod(self, orginalSelector, method_getImplementation(customMethod), method_getTypeEncoding(customMethod)) {
            class_replaceMethod(self, customSelector, method_getImplementation(orginalMethod), method_getTypeEncoding(orginalMethod))
        } else {
            method_exchangeImplementations(orginalMethod, customMethod)
        }
    }

    @objc private func customLocaLizedString(forKey key: String,value: String?, table: String?) -> String {
        let module = Bundle(for: FireworkVideoSDK.self)
        let language = UserDefaults.standard.value(forKey: "CustomLanguage") as? String ?? "en"

        guard  let path = module.path(forResource: language, ofType: "lproj"),
               let bundle = Bundle(path: path) else {
            return Bundle.main.customLocaLizedString(forKey: key, value: value, table: table)
        }
        return bundle.customLocaLizedString(forKey: key, value: value, table: table)
    }
}
