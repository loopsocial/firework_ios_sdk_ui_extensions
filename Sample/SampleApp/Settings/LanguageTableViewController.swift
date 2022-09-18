//
//  LanguageTableViewController.swift
//  SampleApp
//
//  Created by Andres Lara on 9/18/22.
//

import UIKit

class LanguageTableViewController: UITableViewController {
    override func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
       let cell = tableView.cellForRow(at: indexPath)
        let language = cell?.textLabel?.text
        UserDefaults.standard.set(language, forKey: "CustomLanguage")
        self.navigationController?.popViewController(animated: true)
    }
}
