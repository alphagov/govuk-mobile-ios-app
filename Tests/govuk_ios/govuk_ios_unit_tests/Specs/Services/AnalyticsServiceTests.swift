import UIKit
import Foundation
import XCTest
import Logging

@testable import govuk_ios

final class AnalyticsServiceTests: XCTestCase {
    let mockLoggingAnalyticsService = MockLoggingAnalyticsService()

    func test_trackEvent_tracksEvents() {
        let mockUserDefaults = UserDefaults()
        let subject = AnalyticsService(
            analytics: mockLoggingAnalyticsService,
            preferenceStore: mockUserDefaults
        )

        subject.track(event: AppEvent.appLoaded)

        XCTAssertEqual(mockLoggingAnalyticsService.eventsParamsLogged?.count, 1)
    }

    func test_trackScreen_tracksScreen() {
        let subject = AnalyticsService(
            analytics: mockLoggingAnalyticsService,
            preferenceStore: .standard
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

    func test_setAcceptedAnalytics_true_grantsPermissions() {
        let mockUserDefaults = UserDefaults()
        let subject = AnalyticsService(
            analytics: mockLoggingAnalyticsService,
            preferenceStore: mockUserDefaults
        )

        subject.setAcceptedAnalytics(accepted: true)

        XCTAssertEqual(mockLoggingAnalyticsService.hasAcceptedAnalytics, true)
        XCTAssertTrue(mockLoggingAnalyticsService._receivedGrantAnalyticsPermission)
        XCTAssertFalse(mockLoggingAnalyticsService._receivedDenyAnalyticsPermission)
    }

    func test_setAcceptedAnalytics_false_denysPermission() {
        let mockUserDefaults = UserDefaults()
        let subject = AnalyticsService(
            analytics: mockLoggingAnalyticsService,
            preferenceStore: mockUserDefaults
        )

        subject.setAcceptedAnalytics(accepted: false)

        XCTAssertEqual(mockLoggingAnalyticsService.hasAcceptedAnalytics, false)
        XCTAssertFalse(mockLoggingAnalyticsService._receivedGrantAnalyticsPermission)
        XCTAssertTrue(mockLoggingAnalyticsService._receivedDenyAnalyticsPermission)
    }

    func test_permissionState_notSet_returnsUnknown() {
        let mockUserDefaults = UserDefaults()
        let subject = AnalyticsService(
            analytics: mockLoggingAnalyticsService,
            preferenceStore: mockUserDefaults
        )

        mockUserDefaults.set(nil, forKey: "hasAskedForAnalyticsPermissions")
        mockUserDefaults.set(nil, forKey: "hasAcceptedAnalytics")
        mockUserDefaults.synchronize()

        XCTAssertEqual(subject.permissionState, .unknown)
    }

    func test_permissionState_granted_returnsAccepted() {
        let mockUserDefaults = UserDefaults()
        let subject = AnalyticsService(
            analytics: mockLoggingAnalyticsService,
            preferenceStore: mockUserDefaults
        )

        mockUserDefaults.set(true, forKey: "hasAskedForAnalyticsPermissions")
        mockUserDefaults.set(true, forKey: "hasAcceptedAnalytics")
        mockUserDefaults.synchronize()

        XCTAssertEqual(subject.permissionState, .accepted)
    }

    func test_permissionState_rejected_returnsDenied() {
        let mockUserDefaults = UserDefaults()
        let subject = AnalyticsService(
            analytics: mockLoggingAnalyticsService,
            preferenceStore: mockUserDefaults
        )

        mockUserDefaults.set(true, forKey: "hasAskedForAnalyticsPermissions")
        mockUserDefaults.set(false, forKey: "hasAcceptedAnalytics")
        mockUserDefaults.synchronize()

        XCTAssertEqual(subject.permissionState, .denied)
    }
}
