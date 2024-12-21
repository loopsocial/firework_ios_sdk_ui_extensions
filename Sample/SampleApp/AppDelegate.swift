//
//  AppDelegate.swift
//  SampleApp
//
//  Created by Luke Davis on 9/1/22.
//

import UIKit
import FireworkVideo
import FireworkVideoUI
import AppTrackingTransparency

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FireworkVideoSDK.initializeSDK()
        
        let languageName = AppLanguageUtil.shared.getCachedAppLanguageName() ?? "System"
        let language = AppLanguageUtil.shared.getLanguageFromName(name: languageName)
        AppLanguageManager.shared.changeAppLanguage(language)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.requestIDFAPermision()
        }
        return true
    }

    func requestIDFAPermision() {
        if #available(iOS 14.5, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    debugPrint("ATT permission authorized")
                case .denied:
                    debugPrint("ATT permission denied")
                case .notDetermined:
                    debugPrint("ATT permission notDetermined")
                case .restricted:
                    debugPrint("ATT permission restricted")
                    break
                @unknown default:
                    break
                }
            }
        } else {}
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running,
        // this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
