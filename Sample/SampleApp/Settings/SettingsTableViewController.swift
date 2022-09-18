//
//  SettingsTableViewController.swift
//  SampleApp
//
//  Created by Andres Lara on 9/18/22.
//

import UIKit
import FireworkVideo

class SettingsTableViewController: UITableViewController {

    @IBOutlet private weak var selectedLanguageLabel: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        let language = UserDefaults.standard.value(forKey: "CustomLanguage") as? String ?? "en"
        selectedLanguageLabel.text = language
    }
}
