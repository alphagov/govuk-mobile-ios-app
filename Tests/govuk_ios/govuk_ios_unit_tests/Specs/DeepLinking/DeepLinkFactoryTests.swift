import UIKit
import Foundation
import XCTest

@testable import govuk_ios

class DeepLinkFactoryTests: XCTestCase {

    func test_fetchDeepLink_withMatchingPath_returnsDeepLink() {
        let expectedPath = "/test"
        let expectedResult = MockDeepLink(path: expectedPath)
        let store = MockDeepLinkStore(
            deeplinks: [
                expectedResult,
                MockDeepLink(path: "/another-test"),
            ]
        )
        let subject = DeepLinkFactory(deepLinkStore: store)
        let result = subject.fetchDeepLink(path: expectedPath)
        XCTAssertEqual(result?.path, expectedPath)
    }

    func test_fetchDeepLink_noMatchingPath_returnsDeepLink() {
        let expectedPath = "/test123"
        let store = MockDeepLinkStore(
            deeplinks: [
                MockDeepLink(path: "/test"),
                MockDeepLink(path: "/another-test"),
            ]
        )
        let subject = DeepLinkFactory(deepLinkStore: store)
        let result = subject.fetchDeepLink(path: expectedPath)
        XCTAssertNil(result)
    }

}
