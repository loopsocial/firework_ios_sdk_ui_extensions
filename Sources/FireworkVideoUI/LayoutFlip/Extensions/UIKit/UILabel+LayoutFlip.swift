//
//  UILabel+LayoutFlip.swift
//
//  Created by linjie jiang on 4/25/23.
//

import UIKit

private let gNoUseClasses: [String] = [
    "VUlUZXh0RmllbGRMYWJlbA==".decodeBase64String() // UITextFieldLabel
]
private let gSuperviewNoUseClasses: [String] = [
    "VUlEYXRlUGlja2VyQ29udGVudFZpZXc=".decodeBase64String() // UIDatePickerContentView
]

extension UILabel {
    func shouldUseCalculatedTextAlignment() -> Bool {
        for className in gNoUseClasses {
            if let cls = NSClassFromString(className),
               self.isKind(of: cls) {
                return false
            }
        }

        for className in gSuperviewNoUseClasses {
            if let cls = NSClassFromString(className),
               let superview = superview,
               superview.isKind(of: cls) {
                return false
            }
        }

        return true
    }
}
