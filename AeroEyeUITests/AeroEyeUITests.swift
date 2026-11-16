//
//  AeroEyeUITests.swift
//  AeroEyeUITests
//
//  Created by Ruben Alves on 29/10/2026.
//

import XCTest

final class AeroEyeUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoginAndTabNavigation() throws {
        let app = XCUIApplication()
        app.launch()

        let emailField = app.textFields["Email or username"]
        XCTAssertTrue(emailField.waitForExistence(timeout: 8))
        emailField.tap()
        emailField.typeText("demo@aeroeye.com")

        let passwordField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordField.waitForExistence(timeout: 3))
        passwordField.tap()
        passwordField.typeText("password")

        app.buttons.matching(NSPredicate(format: "label CONTAINS 'Sign In'")).firstMatch.tap()

        XCTAssertTrue(app.staticTexts["Machine Monitor"].waitForExistence(timeout: 8))

        app.buttons["Drone"].tap()
        XCTAssertTrue(app.staticTexts["Live Stream"].waitForExistence(timeout: 3))

        app.buttons["AR"].tap()
        XCTAssertTrue(app.staticTexts["AR Mode"].waitForExistence(timeout: 3))

        app.buttons["Dashboard"].tap()
        XCTAssertTrue(app.staticTexts["Machine Monitor"].waitForExistence(timeout: 3))
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
