//
//  AppLanguageManagerTests.swift
//
//  Created by linjie jiang on 4/8/23.
//

import XCTest
@testable import FireworkVideoUI

final class AppLanguageManagerTests: XCTestCase {
    override func setUp() {
        AppLanguageManager.shared.changeAppLanguage(nil)
        AppLanguageManager.shared.systemLanguage = "en"
    }
    
    override func tearDown() {
        
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testChangeAppLanguageToArabic() throws {
        AppLanguageManager.shared.changeAppLanguage("ar")
        XCTAssertEqual(AppLanguageManager.shared.appLanguage, "ar")
        XCTAssertEqual(AppLanguageManager.shared.appLanguageCode, "ar")
        XCTAssertEqual(AppLanguageManager.shared.appLanguageLayoutDirection, .rtl)
        XCTAssertEqual(AppLanguageManager.shared.shouldHorizontalFlip, true)
    }
    
    func testChangeAppLanguageToPortuguese() throws {
        AppLanguageManager.shared.changeAppLanguage("pt-BR")
        XCTAssertEqual(AppLanguageManager.shared.appLanguage, "pt-BR")
        XCTAssertEqual(AppLanguageManager.shared.appLanguageCode, "pt")
        XCTAssertEqual(AppLanguageManager.shared.appLanguageLayoutDirection, .ltr)
        XCTAssertEqual(AppLanguageManager.shared.shouldHorizontalFlip, false)
    }
}
