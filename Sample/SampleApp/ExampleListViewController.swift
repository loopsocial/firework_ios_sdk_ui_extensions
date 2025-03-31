//
//  ExampleListViewController.swift
//  SampleApp
//
//  Created by linjie jiang on 4/8/23.
//

import UIKit
import FireworkVideoUI

class ExampleListViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let languageName = AppLanguageUtil.shared.getCachedAppLanguageName() ?? "System"
        self.navigationItem.title = "Examples(\(languageName))"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gearshape.2"),
            style: .plain,
            target: self,
            action: #selector(ExampleListViewController.onChangeAppLanguage))
    }
    
    @objc func onChangeAppLanguage() {
        let actionSheet = UIAlertController(title: "Change App Language", message: nil, preferredStyle: .actionSheet)
        let languageNameList = ["English", "Arabic", "Japanese", "Portuguese (Brazil)", "System"]
        for languageName in languageNameList {
            actionSheet.addAction(UIAlertAction(title: languageName, style: .default, handler: { [weak self] action in
                guard let self = self else {
                    return
                }
                
                let language = AppLanguageUtil.shared.getLanguageFromName(name: languageName)
                if language == "ar" {
                    UIView.appearance().semanticContentAttribute = .forceRightToLeft
                } else {
                    UIView.appearance().semanticContentAttribute = .forceLeftToRight
                }
                AppLanguageManager.shared.changeAppLanguage(language)
                AppLanguageUtil.shared.cacheAppLanguageName(languageName)
                self.navigationItem.title = "Examples(\(languageName))"
            }))
        }

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(actionSheet, animated: true)
    }
}
