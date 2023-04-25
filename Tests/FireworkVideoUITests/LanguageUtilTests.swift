//
//  LanguageUtilTests.swift
//  
//
//  Created by linjie jiang on 4/8/23.
//

import XCTest
@testable import FireworkVideoUI

final class LanguageUtilTests: XCTestCase {
    
    func testGetLanguageCode() throws {
        XCTAssertEqual(LanguageUtil.getLanguageCode("pt-BR"), "pt")
        XCTAssertEqual(LanguageUtil.getLanguageCode("ar"), "ar")
    }
    
    func testIsValidLanguage() throws {
        XCTAssertEqual(LanguageUtil.isValidLanguage("pt-BR"), true)
        XCTAssertEqual(LanguageUtil.isValidLanguage("ar"), true)
    }
}
