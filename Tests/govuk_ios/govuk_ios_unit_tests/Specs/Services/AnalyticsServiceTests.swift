import UIKit
import Foundation
import XCTest
import Logging

@testable import govuk_ios

final class AnalyticsServiceTests: XCTestCase {
    let mockLoggingAnalyticsService = MockLoggingAnalyticsService()
    let mockAnalyticsPreferenceStore = MockAnalyticsPreferenceStore()

    func test_trackEvent_tracksEvents() {
        let subject = AnalyticsService(
            analytics: mockLoggingAnalyticsService,
            preferenceStore: mockAnalyticsPreferenceStore
        )

        subject.track(event: AppEvent.appLoaded)

        XCTAssertEqual(mockLoggingAnalyticsService.eventsParamsLogged?.count, 1)
    }

    func test_trackScreen_tracksScreen() {
        let subject = AnalyticsService(
            analytics: mockLoggingAnalyticsService,
            preferenceStore: mockAnalyticsPreferenceStore
        )

        let mockViewController = MockBaseViewController()
        subject.track(screen: mockViewController)

        let receivedParams = mockLoggingAnalyticsService._trackScreenV2ReceivedParameters
        XCTAssertEqual(receivedParams.count, 1)
        let params = receivedParams.first
        XCTAssertEqual(params?["screen_name"] as? String, "test_mock_tracking_name")
        XCTAssertEqual(params?["language"] as? String, Locale.current.languageCode)
        XCTAssertEqual(params?["screen_class"] as? String, "MockBaseViewController")

        let screens = mockLoggingAnalyticsService._trackScreenV2ReceivedScreens
        XCTAssertEqual(screens.count, 1)
        XCTAssertEqual(screens.first?.name, mockViewController.trackingName)
        XCTAssertEqual(screens.first?.type.name, mockViewController.trackingClass)
    }

    func test_setAcceptedAnalytics_setsPreference() {
        let subject = AnalyticsService(
            analytics: mockLoggingAnalyticsService,
            preferenceStore: mockAnalyticsPreferenceStore
        )

        subject.setAcceptedAnalytics(accepted: true)

        XCTAssertEqual(mockAnalyticsPreferenceStore.hasAcceptedAnalytics, true)
    }

    func test_permissionState_notSet_returnsUnknown() {
        let subject = AnalyticsService(
            analytics: mockLoggingAnalyticsService,
            preferenceStore: mockAnalyticsPreferenceStore
        )

        XCTAssertEqual(subject.permissionState, .unknown)
    }

    func test_permissionState_granted_returnsAccepted() {
        let subject = AnalyticsService(
            analytics: mockLoggingAnalyticsService,
            preferenceStore: mockAnalyticsPreferenceStore
        )

        subject.setAcceptedAnalytics(accepted: true)

        XCTAssertEqual(subject.permissionState, .accepted)
    }

    func test_permissionState_rejected_returnsDenied() {
        let subject = AnalyticsService(
            analytics: mockLoggingAnalyticsService,
            preferenceStore: mockAnalyticsPreferenceStore
        )

        subject.setAcceptedAnalytics(accepted: false)

        XCTAssertEqual(subject.permissionState, .denied)
    }
}
