import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
struct String_ExtensionsTests {
    @Test
    func common_hasCorrectValues() {
        let sut = String.common
        #expect(sut.tableName == "Common")
    }

    @Test
    func home_hasCorrectValues() {
        let sut = String.home
        #expect(sut.tableName == "Home")
    }

    @Test
    func settings_hasCorrectValues() {
        let sut = String.settings
        #expect(sut.tableName == "Settings")
    }

    @Test
    func search_hasCorrectValues() {
        let sut = String.search
        #expect(sut.tableName == "Search")
    }

    @Test
    func onboarding_hasCorrectValues() {
        let sut = String.onboarding
        #expect(sut.tableName == "Onboarding")
    }

    @Test
    func localized_returnsExpectedResult() {
        let sut = String.LocalStringBuilder(
            tableName: "TestStrings",
            bundle: .current
        )
        #expect(sut.localized("testString") == "Test string 123")
    }
}
