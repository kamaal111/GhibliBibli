//
//  GhibliBibliUITests.swift
//  GhibliBibliUITests
//
//  Created by Kamaal M Farah on 25/01/2021.
//

import XCTest

class GhibliBibliUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testExample() throws {
        app.launch()
    }

    private func attachScreenshot(name: String) {
        let screenshot = app.windows.firstMatch.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        self.add(attachment)
    }
}
