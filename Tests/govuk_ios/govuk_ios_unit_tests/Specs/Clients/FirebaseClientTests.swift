import Foundation
import XCTest

import FirebaseAnalytics

@testable import govuk_ios

class FirebaseClientTests: XCTestCase {

    func test_launch_configuresFirebaseApp() {
        let mockApp = MockFirebaseApp.self
        let mockAnalytics = MockFirebaseAnalytics.self
        let sut = FirebaseClient(
            firebaseApp: mockApp,
            firebaseAnalytics: mockAnalytics
        )

        MockFirebaseApp._configureCalled = false
        sut.launch()

        XCTAssertTrue(mockApp._configureCalled)
    }

    func test_setEnabled_true_enablesAnalytics() {
        let mockApp = MockFirebaseApp.self
        let mockAnalytics = MockFirebaseAnalytics.self
        let sut = FirebaseClient(
            firebaseApp: mockApp,
            firebaseAnalytics: mockAnalytics
        )

        mockAnalytics.clearValues()
        sut.setEnabled(enabled: true)

        XCTAssertEqual(mockAnalytics._setAnalyticsCollectionEnabledReveivedEnabled, true)
    }

    func test_setEnabled_false_disablesAnalytics() {
        let mockApp = MockFirebaseApp.self
        let mockAnalytics = MockFirebaseAnalytics.self
        let sut = FirebaseClient(
            firebaseApp: mockApp,
            firebaseAnalytics: mockAnalytics
        )

        mockAnalytics.clearValues()
        sut.setEnabled(enabled: false)

        XCTAssertEqual(mockAnalytics._setAnalyticsCollectionEnabledReveivedEnabled, false)
    }

    func test_trackEvent_noParams_tracksExpectedEvent() {
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

        XCTAssertEqual(mockAnalytics._logEventReceivedEventName, expectedName)
        XCTAssertEqual(mockAnalytics._logEventReceivedEventParameters?.isEmpty, true)
    }

    func test_trackEvent_withParams_tracksExpectedEvent() {
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

        XCTAssertEqual(mockAnalytics._logEventReceivedEventName, expectedName)
        let receivedParams = mockAnalytics._logEventReceivedEventParameters
        XCTAssertEqual(receivedParams?.count, 1)
        XCTAssertEqual(receivedParams?["test_param"] as? String, expectedValue)
    }

    func test_trackScreen_tracksExpectedEvent() {
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

        XCTAssertEqual(mockAnalytics._logEventReceivedEventName, AnalyticsEventScreenView)
        let receivedParams = mockAnalytics._logEventReceivedEventParameters
        XCTAssertEqual(receivedParams?.count, 4)
        XCTAssertEqual(receivedParams?[AnalyticsParameterScreenName] as? String, expectedScreen.trackingName)
        XCTAssertEqual(receivedParams?[AnalyticsParameterScreenClass] as? String, expectedScreen.trackingClass)
        XCTAssertEqual(receivedParams?["screen_title"] as? String, expectedTitle)
        XCTAssertEqual(receivedParams?["language"] as? String, expectedScreen.trackingLanguage)
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
