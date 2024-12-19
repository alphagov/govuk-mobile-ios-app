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
    func topics_hasCorrectValues() {
        let sut = String.topics
        #expect(sut.tableName == "Topics")
    }

    @Test
    func localized_returnsExpectedResult() {
        let sut = String.LocalStringBuilder(
            tableName: "TestStrings",
            bundle: .current
        )
        #expect(sut.localized("testString") == "Test string 123")
    }

    @Test(arguments: zip(
        [
            "1.0.0",
            "1",
            "1.0",
            "1.0.0",
            "0.0.100"
        ],
        [
            "1.0.1",
            "2.0.0",
            "2.0",
            "2",
            "100.0.0"
        ]
    ))
    func isVersion_lessThanTarget_returnsTrue(version: String, targetVersion: String) {
        let result = version.isVersion(lessThan: targetVersion)
        #expect(result == true)
    }

    @Test(arguments: zip(
        [
            "1.0.1",
            "2.0.0",
            "2.0",
            "2",
            "100.0.0"
        ],
        [
            "1.0.0",
            "1",
            "1.0",
            "1.0.0",
            "0.0.100"
        ]
    ))
    func isVersion_notLessThanTarget_returnsFalse(version: String, targetVersion: String) {
        let result = version.isVersion(lessThan: targetVersion)
        #expect(result == false)
    }

    @Test(arguments: zip(
        [
            "100.0.0",
            "0.100.0",
            "0.0.100"
        ],
        [
            "100.0.0",
            "0.100.0",
            "0.0.100"
        ]
    ))
    func isVersion_equalToTarget_returnsFalse(version: String, targetVersion: String) {
        let result = version.isVersion(lessThan: targetVersion)
        #expect(result == false)
    }
}
