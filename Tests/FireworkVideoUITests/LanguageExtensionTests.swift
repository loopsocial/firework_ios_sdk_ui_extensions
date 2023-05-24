//
//  LanguageUtilTests.swift
//  
//
//  Created by linjie jiang on 4/8/23.
//

import XCTest
@testable import FireworkVideoUI

final class LanguageExtensionTests: XCTestCase {
    
    func testGetLanguageCode() throws {
        XCTAssertEqual(LanguageExtension.getLanguageCode("pt-BR"), "pt")
        XCTAssertEqual(LanguageExtension.getLanguageCode("ar"), "ar")
    }
    
    func testIsValidLanguage() throws {
        XCTAssertEqual(LanguageExtension.isValidLanguage("pt-BR"), true)
        XCTAssertEqual(LanguageExtension.isValidLanguage("ar"), true)
    }
}
