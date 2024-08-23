//
//  LanguageCache.swift
//  SampleApp
//
//  Created by linjie jiang on 4/8/23.
//

import Foundation

private let appLanguageNameStorageKey = "sample_app_language_name_storage_key"

public class AppLanguageUtil {
    public static let shared = AppLanguageUtil()
    private init() {}
    
    func getCachedAppLanguageName() -> String? {
        return UserDefaults.standard.object(forKey: appLanguageNameStorageKey) as? String
    }
    
    func cacheAppLanguageName(_ name: String?) {
        guard let name = name else {
            return;
        }
        
        UserDefaults.standard.set(name, forKey: appLanguageNameStorageKey)
        UserDefaults.standard.synchronize()
    }
    
    func getLanguageFromName(name: String) -> String? {
        switch name {
        case "English":
            return "en"
        case "Arabic":
            return "ar"
        case "Japanese":
            return "ja"
        case "Portuguese (Brazil)":
            return "pt-BR"
        case "System":
            return nil
        default:
            return nil
        }
    }
}
