import Foundation
import FirebaseAppCheck
import Testing

import FirebaseAnalytics
import GOVKit

@testable import govuk_ios

@Suite(.serialized)
struct FirebaseClientTests {

    @Test
    func launch_configuresFirebaseApp() {
        let mockApp = MockFirebaseApp.self
        let mockAnalytics = MockFirebaseAnalytics.self
        let sut = FirebaseClient(
            firebaseApp: mockApp,
            firebaseAnalytics: mockAnalytics,
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
            firebaseAnalytics: mockAnalytics,
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
            firebaseAnalytics: mockAnalytics,
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
            firebaseAnalytics: mockAnalytics,
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
            firebaseAnalytics: mockAnalytics,
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
            firebaseAnalytics: mockAnalytics,
        )
        let expectedScreen = MockBaseViewController(analyticsService: MockAnalyticsService())
        let expectedTitle = UUID().uuidString
        expectedScreen.title = expectedTitle
        mockAnalytics.clearValues()
        sut.track(screen: expectedScreen)

        #expect(mockAnalytics._logEventReceivedEventName == AnalyticsEventScreenView)
        let receivedParams = mockAnalytics._logEventReceivedEventParameters
        #expect(receivedParams?.count == 5)
        #expect(receivedParams?[AnalyticsParameterScreenName] as? String == expectedScreen.trackingName)
        #expect(receivedParams?[AnalyticsParameterScreenClass] as? String == expectedScreen.trackingClass)
        #expect(receivedParams?["screen_title"] as? String == expectedTitle)
        #expect(receivedParams?["language"] as? String == expectedScreen.trackingLanguage)
        #expect(receivedParams?["test_param"] as? String
                == expectedScreen.additionalParameters["test_param"] as? String)
    }

    @Test
    @MainActor
    func setUserProperty_setsProperty() {
        let mockApp = MockFirebaseApp.self
        let mockAnalytics = MockFirebaseAnalytics.self
        let sut = FirebaseClient(
            firebaseApp: mockApp,
            firebaseAnalytics: mockAnalytics,
        )
        let expectedName = UUID().uuidString
        let expectedValue = UUID().uuidString
        sut.set(
            userProperty: .init(key: expectedName, value: expectedValue)
        )

        #expect(mockAnalytics._setUserPropertyReveivedName == expectedName)
        #expect(mockAnalytics._setUserPropertyReveivedValue == expectedValue)
    }

    @Test
    func trackError_doesNothing() {
        let mockApp = MockFirebaseApp.self
        mockApp._clearValues()
        let mockAnalytics = MockFirebaseAnalytics.self
        mockAnalytics.clearValues()

        let sut = FirebaseClient(
            firebaseApp: mockApp,
            firebaseAnalytics: mockAnalytics,
        )
        let error = NSError(domain: "test", code: 1)
        sut.track(error: error)

        #expect(mockApp._configureCalled == false)
        #expect(mockAnalytics._setUserPropertyReveivedName == nil)
        #expect(mockAnalytics._setUserPropertyReveivedValue == nil)
    }

}

class MockFirebaseApp: FirebaseAppInterface {
    static var _configureCalled: Bool = false
    static func configure() {
        _configureCalled = true
    }

    static func _clearValues() {
        _configureCalled = false
    }
}

class MockFirebaseAnalytics: FirebaseAnalyticsInterface {
    static func clearValues() {
        _setAnalyticsCollectionEnabledReveivedEnabled = nil
        _logEventReceivedEventName = nil
        _logEventReceivedEventParameters = nil
        _setUserPropertyReveivedName = nil
        _setUserPropertyReveivedValue = nil
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

    static var _setUserPropertyReveivedValue: String?
    static var _setUserPropertyReveivedName: String?
    static func setUserProperty(_ value: String?,
                                forName name: String) {
        _setUserPropertyReveivedValue = value
        _setUserPropertyReveivedName = name
    }
}
