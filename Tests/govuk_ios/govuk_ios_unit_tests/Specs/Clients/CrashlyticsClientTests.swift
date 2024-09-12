import Foundation
import XCTest

@testable import govuk_ios

class CrashlyticsClientTests: XCTestCase {
    func test_setEnabled_true_passesThroughValue() {
        let mockCrashlytics = MockCrashlytics()
        let sut = CrashlyticsClient(
            crashlytics: mockCrashlytics
        )

        sut.setEnabled(enabled: true)

        XCTAssertEqual(mockCrashlytics._setCrashlyticsCollectionEnabledReceivedEnabled, true)
    }

    func test_setEnabled_false_passesThroughValue() {
        let mockCrashlytics = MockCrashlytics()
        let sut = CrashlyticsClient(
            crashlytics: mockCrashlytics
        )

        sut.setEnabled(enabled: false)

        XCTAssertEqual(mockCrashlytics._setCrashlyticsCollectionEnabledReceivedEnabled, false)
    }
}

class MockCrashlytics: CrashlyticsInterface {
    var _setCrashlyticsCollectionEnabledReceivedEnabled: Bool?
    func setCrashlyticsCollectionEnabled(_ newValue: Bool) {
        _setCrashlyticsCollectionEnabledReceivedEnabled = newValue
    }
}
