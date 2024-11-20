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

    @Test
    func launch_exists_doesNothing() {
        let mockCrashlytics = MockCrashlytics()
        let sut = CrashlyticsClient(
            crashlytics: mockCrashlytics
        )

        sut.launch()

        #expect(mockCrashlytics._setCrashlyticsCollectionEnabledReceivedEnabled == nil)
    }

    @Test
    func trackScreen_exists_doesNothing() {
        let mockCrashlytics = MockCrashlytics()
        let sut = CrashlyticsClient(
            crashlytics: mockCrashlytics
        )

        let expectedScreen = MockBaseViewController()
        sut.track(screen: expectedScreen)

        #expect(mockCrashlytics._setCrashlyticsCollectionEnabledReceivedEnabled == nil)
    }

    @Test
    @MainActor
    func trackEvent_exists_doesNothing() {
        let mockCrashlytics = MockCrashlytics()
        let sut = CrashlyticsClient(
            crashlytics: mockCrashlytics
        )

        let expectedScreen = MockBaseViewController()
        sut.track(event: .init(name: "test", params: nil))

        #expect(mockCrashlytics._setCrashlyticsCollectionEnabledReceivedEnabled == nil)
    }

    @Test
    func setUserProperty_exists_doesNothing() {
        let mockCrashlytics = MockCrashlytics()
        let sut = CrashlyticsClient(
            crashlytics: mockCrashlytics
        )

        sut.set(userProperty: .init(key: "test", value: "test"))

        #expect(mockCrashlytics._setCrashlyticsCollectionEnabledReceivedEnabled == nil)
    }
}

class MockCrashlytics: CrashlyticsInterface {
    var _setCrashlyticsCollectionEnabledReceivedEnabled: Bool?
    func setCrashlyticsCollectionEnabled(_ newValue: Bool) {
        _setCrashlyticsCollectionEnabledReceivedEnabled = newValue
    }
}
