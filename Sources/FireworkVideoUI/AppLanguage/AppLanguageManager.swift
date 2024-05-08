//
//  AppLanguageManager.swift
//  
//  Created by linjie jiang on 2023/2/7.
//

import UIKit

private let appLanguageStorageKey = "firework_sdk_app_language_storage_key"

enum LanguageLayoutDirection: Int {
    case ltr, rtl, unsupported
}

/// The manager of supporting app language
public class AppLanguageManager {
    public struct NotificationName {
        /// The notification name for language change
        public static let AppLanguageChanged = Notification.Name(
            rawValue: "firework.notification.name.appLanguageChanged"
        )
    }

    public static let shared = AppLanguageManager()

    var systemLanguage: String?
    private var systemLanguageCode: String? {
        guard let language = systemLanguage else {
            return nil
        }

        return LanguageExtension.getLanguageCode(language)
    }

    /// Get current app language.
    public private(set) var appLanguage: String? {
        didSet {
            if appLanguage != nil {
                AppLanguageManager.swizzelMethods()
                LayoutFlipManager.shared.enableHorizontalFlip = shouldHorizontalFlip
            }

            if appLanguage != oldValue {
                NotificationCenter.default.post(name: NotificationName.AppLanguageChanged, object: nil)
            }
        }
    }

    var appLanguageCode: String? {
        guard let language = appLanguage else {
            return nil
        }

        return LanguageExtension.getLanguageCode(language)
    }

    var appLanguageLayoutDirection: LanguageLayoutDirection? {
        guard let languageCode = appLanguageCode else {
            return nil
        }
        let direction = Locale.characterDirection(forLanguage: languageCode)
        switch direction {
        case .leftToRight:
            return .ltr
        case .rightToLeft:
            return .rtl
        default:
            return .unsupported
        }
    }
    
    var systemLanguageLayoutDirection: LanguageLayoutDirection? {
        guard let languageCode = systemLanguageCode else {
            return nil
        }
        let direction = Locale.characterDirection(forLanguage: languageCode)
        switch direction {
        case .leftToRight:
            return .ltr
        case .rightToLeft:
            return .rtl
        default:
            return .unsupported
        }
    }

    var shouldHorizontalFlip: Bool {
        if appLanguageLayoutDirection == .rtl,
           systemLanguageLayoutDirection == .ltr {
            return true
        }
        
        if appLanguageLayoutDirection == .ltr,
           systemLanguageLayoutDirection == .rtl {
            return true
        }

        return false
    }

    private static func swizzelMethods() {
        DispatchQueue.once {
            UIViewController.swizzleViewControllerMethodsForAppLanguage()
            Bundle.swizzleBundleMethodsForAppLanguage()
            URLSession.swizzleURLSessionMethodsForAppLanguage()
            NumberFormatter.swizzleNumberFormatterMethodsForAppLanguage()
            UIImageView.swizzleImageViewMethodsForAppLanguage()
            UILabel.swizzleLabelMethodsForAppLanguage()
            UITextField.swizzleTextFieldMethodsForAppLanguage()
            UITextView.swizzleTextViewMethodsForAppLanguage()
            UIWindow.swizzleWindowMethodsForAppLanguage()
            UIView.swizzleViewMethodsForAppLanguage()
            NSLocale.swizzleNSLocaleMethodsForAppLanguage()
        }

        LayoutFlipManager.swizzelMethods()
    }

    private init() {
        initializeManager()
    }

    private func initializeManager() {
        self.systemLanguage = Locale.preferredLanguages.first
        let cachedAppLanguage = UserDefaults.standard.object(forKey: appLanguageStorageKey) as? String
        if LanguageExtension.isValidLanguage(cachedAppLanguage) {
            self.appLanguage = cachedAppLanguage
        }
    }

    /// Change app language
    ///
    /// - Parameters:
    ///    - language: app language. We will use system langauge when language is nil.
    /// - Returns: The result of changing app language.
    @discardableResult
    public func changeAppLanguage(_ language: String?) -> Bool {
        guard let language = language, language.count > 0 else {
            appLanguage = nil
            UserDefaults.standard.removeObject(forKey: appLanguageStorageKey)
            UserDefaults.standard.synchronize()
            return true
        }

        if LanguageExtension.isValidLanguage(language) {
            appLanguage = language
            UserDefaults.standard.set(language, forKey: appLanguageStorageKey)
            UserDefaults.standard.synchronize()
            return true
        } else {
            return false
        }
    }
}
