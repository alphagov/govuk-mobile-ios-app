import Foundation
import Testing

import FirebaseAnalytics

@testable import govuk_ios

@Suite(.serialized)
struct FirebaseClientTests {

    @Test
    func launch_configuresFirebaseApp() {
        let mockApp = MockFirebaseApp.self
        let mockAnalytics = MockFirebaseAnalytics.self
        let sut = FirebaseClient(
            firebaseApp: mockApp,
            firebaseAnalytics: mockAnalytics
        )

        MockFirebaseApp._configureCalled = false
        sut.launch()

        #expect(mockApp._configureCalled)
    }

    @Test
    func setEnabled_true_enablesAnalytics() {
        let mockApp = MockFirebaseApp.self
        let mockAnalytics = MockFirebaseAnalytics.self
        let sut = FirebaseClient(
            firebaseApp: mockApp,
            firebaseAnalytics: mockAnalytics
        )

        mockAnalytics.clearValues()
        sut.setEnabled(enabled: true)

        #expect(mockAnalytics._setAnalyticsCollectionEnabledReveivedEnabled == true)
    }

    @Test
    func setEnabled_false_disablesAnalytics() {
        let mockApp = MockFirebaseApp.self
        let mockAnalytics = MockFirebaseAnalytics.self
        let sut = FirebaseClient(
            firebaseApp: mockApp,
            firebaseAnalytics: mockAnalytics
        )

        mockAnalytics.clearValues()
        sut.setEnabled(enabled: false)

        #expect(mockAnalytics._setAnalyticsCollectionEnabledReveivedEnabled == false)
    }

    @Test
    func trackEvent_noParams_tracksExpectedEvent() {
        let mockApp = MockFirebaseApp.self
        let mockAnalytics = MockFirebaseAnalytics.self
        let sut = FirebaseClient(
            firebaseApp: mockApp,
            firebaseAnalytics: mockAnalytics
        )
        let expectedName = UUID().uuidString
        let expectedEvent = AppEvent(
            name: expectedName,
            params: nil
        )
        sut.track(event: expectedEvent)

        #expect(mockAnalytics._logEventReceivedEventName == expectedName)
        #expect(mockAnalytics._logEventReceivedEventParameters?.isEmpty == true)
    }

    @Test
    func trackEvent_withParams_tracksExpectedEvent() {
        let mockApp = MockFirebaseApp.self
        let mockAnalytics = MockFirebaseAnalytics.self
        let sut = FirebaseClient(
            firebaseApp: mockApp,
            firebaseAnalytics: mockAnalytics
        )
        let expectedName = UUID().uuidString
        let expectedValue = UUID().uuidString
        let expectedParams: [String: Any] = [
            "test_param": expectedValue
        ]
        let expectedEvent = AppEvent(
            name: expectedName,
            params: expectedParams
        )

        mockAnalytics.clearValues()
        sut.track(event: expectedEvent)

        #expect(mockAnalytics._logEventReceivedEventName == expectedName)
        let receivedParams = mockAnalytics._logEventReceivedEventParameters
        #expect(receivedParams?.count == 1)
        #expect(receivedParams?["test_param"] as? String == expectedValue)
    }

    @Test
    @MainActor
    func trackScreen_tracksExpectedEvent() {
        let mockApp = MockFirebaseApp.self
        let mockAnalytics = MockFirebaseAnalytics.self
        let sut = FirebaseClient(
            firebaseApp: mockApp,
            firebaseAnalytics: mockAnalytics
        )
        let expectedScreen = MockBaseViewController()
        let expectedTitle = UUID().uuidString
        expectedScreen.title = expectedTitle
        mockAnalytics.clearValues()
        sut.track(screen: expectedScreen)

        #expect(mockAnalytics._logEventReceivedEventName == AnalyticsEventScreenView)
        let receivedParams = mockAnalytics._logEventReceivedEventParameters
        #expect(receivedParams?.count == 4)
        #expect(receivedParams?[AnalyticsParameterScreenName] as? String == expectedScreen.trackingName)
        #expect(receivedParams?[AnalyticsParameterScreenClass] as? String == expectedScreen.trackingClass)
        #expect(receivedParams?["screen_title"] as? String == expectedTitle)
        #expect(receivedParams?["language"] as? String == expectedScreen.trackingLanguage)
    }
}

class MockFirebaseApp: FirebaseAppInterface {
    static var _configureCalled: Bool = false
    static func configure() {
        _configureCalled = true
    }
}

class MockFirebaseAnalytics: FirebaseAnalyticsInterface {

    static func clearValues() {
        _setAnalyticsCollectionEnabledReveivedEnabled = nil
        _logEventReceivedEventName = nil
        _logEventReceivedEventParameters = nil
    }

    static var _setAnalyticsCollectionEnabledReveivedEnabled: Bool?
    static func setAnalyticsCollectionEnabled(_ newValue: Bool) {
        _setAnalyticsCollectionEnabledReveivedEnabled = newValue
    }
    
    static var _logEventReceivedEventName: String?
    static var _logEventReceivedEventParameters: [String : Any]?
    static func logEvent(_ eventName: String,
                         parameters: [String : Any]?) {
        _logEventReceivedEventName = eventName
        _logEventReceivedEventParameters = parameters
    }
}
