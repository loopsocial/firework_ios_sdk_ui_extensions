//
//  String+Base64.swift
//
//  Created by linjie jiang on 4/25/23.
//

import Foundation

extension String {
    func decodeBase64String() -> String {
        if let decodedData = Data(base64Encoded: self),
           let decodedString = String(data: decodedData, encoding: .utf8) {
            return decodedString
        }

        return ""
    }
}
