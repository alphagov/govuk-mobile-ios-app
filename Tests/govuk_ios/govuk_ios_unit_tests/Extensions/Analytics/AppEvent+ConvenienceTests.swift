import Foundation

@testable import govuk_ios

import XCTest

class AppEvent_ConvenienceTests: XCTestCase {
    func test_appLoaded_returnsExpectedResult() {
        let result = AppEvent.appLoaded

        XCTAssertEqual(result.name, "app_loaded")
        XCTAssertEqual(result.params?.count, 1)
        XCTAssertEqual(result.params?["device_model"] as? String, DeviceModel().description)
    }

    func test_navigation_returnsExpectedResult() {
        let expectedText = UUID().uuidString
        let expectedType = UUID().uuidString
        let expectedExternal = Int.random(in: 1...100) % 2 == 0
        let result = AppEvent.navigation(
            text: expectedText,
            type: expectedType,
            external: expectedExternal
        )

        XCTAssertEqual(result.name, "Navigation")
        XCTAssertEqual(result.params?.count, 4)
        XCTAssertEqual(result.params?["text"] as? String, expectedText)
        XCTAssertEqual(result.params?["type"] as? String, expectedType)
        XCTAssertEqual(result.params?["external"] as? Bool, expectedExternal)
        XCTAssertEqual(result.params?["language"] as? String, "en")
    }

    func test_tabNavigation_returnsExpectedResult() {
        let expectedText = UUID().uuidString
        let result = AppEvent.tabNavigation(
            text: expectedText
        )

        XCTAssertEqual(result.name, "Navigation")
        XCTAssertEqual(result.params?.count, 4)
        XCTAssertEqual(result.params?["text"] as? String, expectedText)
        XCTAssertEqual(result.params?["type"] as? String, "Tab")
        XCTAssertEqual(result.params?["external"] as? Bool, false)
        XCTAssertEqual(result.params?["language"] as? String, "en")
    }

    func test_buttonNavigation_external_returnsExpectedResult() {
        let expectedText = UUID().uuidString
        let result = AppEvent.buttonNavigation(
            text: expectedText,
            external: true
        )

        XCTAssertEqual(result.name, "Navigation")
        XCTAssertEqual(result.params?.count, 4)
        XCTAssertEqual(result.params?["text"] as? String, expectedText)
        XCTAssertEqual(result.params?["type"] as? String, "Button")
        XCTAssertEqual(result.params?["external"] as? Bool, true)
        XCTAssertEqual(result.params?["language"] as? String, "en")
    }

    func test_buttonNavigation_internal_returnsExpectedResult() {
        let expectedText = UUID().uuidString
        let result = AppEvent.buttonNavigation(
            text: expectedText,
            external: false
        )

        XCTAssertEqual(result.name, "Navigation")
        XCTAssertEqual(result.params?.count, 4)
        XCTAssertEqual(result.params?["text"] as? String, expectedText)
        XCTAssertEqual(result.params?["type"] as? String, "Button")
        XCTAssertEqual(result.params?["external"] as? Bool, false)
        XCTAssertEqual(result.params?["language"] as? String, "en")
    }

    func test_searchTerm_returnsExpectedResult() {
        let expectedTerm = UUID().uuidString
        let result = AppEvent.searchTerm(term: expectedTerm)

        XCTAssertEqual(result.name, "Search")
        XCTAssertEqual(result.params?.count, 1)
        XCTAssertEqual(result.params?["text"] as? String, expectedTerm)
    }
}
