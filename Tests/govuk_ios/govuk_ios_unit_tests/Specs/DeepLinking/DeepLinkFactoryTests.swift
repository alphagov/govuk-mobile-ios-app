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


    // new tests
    func test_fetchDeepLink_success() {
        let expectedPath = "/test/1234"
        let expectedResult = MockDeepLink(path: expectedPath)
        let store = MockDeepLinkStore(
            deeplinks: [
                MockDeepLink(path: "/test/1234"),
                MockDeepLink(path: "/another-test"),
            ]
        )
        let subject = DeepLinkFactory(deepLinkStore: store)
        let result = subject.fetchDeepLink(path: expectedPath)
        XCTAssertNil(result)
    }

    func test_fetchDeepLink_success2() {
        let expectedPath = "/topic?topic_id=1234"
        let expectedResult = MockDeepLink(path: expectedPath)
        let store = MockDeepLinkStore(
            deeplinks: [
                MockDeepLink(path: "/topic?topic_id=1234"),
                MockDeepLink(path: "/another-test"),
            ]
        )
        let subject = DeepLinkFactory(deepLinkStore: store)
        let result = subject.fetchDeepLink(path: expectedPath)
        XCTAssertNil(result)
    }

    func test_fetchDeepLink_success3() {
        let expectedPath = "/driving/permit?permit_id=1234"
        let expectedResult = MockDeepLink(path: expectedPath)
        let store = MockDeepLinkStore(
            deeplinks: [
                MockDeepLink(path: "/driving/permit?permit_id=1234"),
                MockDeepLink(path: "/another-test"),
            ]
        )
        let subject = DeepLinkFactory(deepLinkStore: store)
        let result = subject.fetchDeepLink(path: expectedPath)
        XCTAssertNil(result)
    }

    func test_fetchDeepLink_success4() {
        let expectedPath = "/driving/permit?permit_id=1234"
        let expectedResult = MockDeepLink(path: expectedPath)
        let store = MockDeepLinkStore(
            deeplinks: [
                MockDeepLink(path: "/driving/permit?permit_id=1234&tax_id=9876"),
                MockDeepLink(path: "/another-test"),
            ]
        )
        let subject = DeepLinkFactory(deepLinkStore: store)
        let result = subject.fetchDeepLink(path: expectedPath)
        XCTAssertNil(result)
    }
}
