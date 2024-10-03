import Foundation
import Testing

@testable import govuk_ios

@Suite
struct CrashlyticsClientTests {
    @Test
    func setEnabled_true_passesThroughValue() {
        let mockCrashlytics = MockCrashlytics()
        let sut = CrashlyticsClient(
            crashlytics: mockCrashlytics
        )

        sut.setEnabled(enabled: true)

        #expect(mockCrashlytics._setCrashlyticsCollectionEnabledReceivedEnabled == true)
    }

    @Test
    func setEnabled_false_passesThroughValue() {
        let mockCrashlytics = MockCrashlytics()
        let sut = CrashlyticsClient(
            crashlytics: mockCrashlytics
        )

        sut.setEnabled(enabled: false)

        #expect(mockCrashlytics._setCrashlyticsCollectionEnabledReceivedEnabled == false)
    }
}

class MockCrashlytics: CrashlyticsInterface {
    var _setCrashlyticsCollectionEnabledReceivedEnabled: Bool?
    func setCrashlyticsCollectionEnabled(_ newValue: Bool) {
        _setCrashlyticsCollectionEnabledReceivedEnabled = newValue
    }
}
