import UIKit
import Foundation
import XCTest

@testable import govuk_ios

final class AnalyticsServiceTests: XCTestCase {
    var mockAnalyticsClient: MockAnalyticsClient!

    override func setUp() {
        mockAnalyticsClient = MockAnalyticsClient()
    }

    func test_permissionState_notSet_returnsUnknown() {
        let mockUserDefaults = UserDefaults()
        let subject = AnalyticsService(
            clients: [mockAnalyticsClient],
            userDefaults: mockUserDefaults
        )
        mockUserDefaults.setValue(nil, forKey: UserDefaultsKeys.acceptedAnalytics.rawValue)

        XCTAssertEqual(subject.permissionState, .unknown)
    }

    func test_permissionState_accepted_returnsAccepted() {
        let mockUserDefaults = UserDefaults()
        let subject = AnalyticsService(
            clients: [mockAnalyticsClient],
            userDefaults: mockUserDefaults
        )
        mockUserDefaults.set(bool: true, forKey: .acceptedAnalytics)

        XCTAssertEqual(subject.permissionState, .accepted)
    }

    func test_permissionState_rejected_returnsDenied() {
        let mockUserDefaults = UserDefaults()
        let subject = AnalyticsService(
            clients: [mockAnalyticsClient],
            userDefaults: mockUserDefaults
        )
        mockUserDefaults.set(bool: false, forKey: .acceptedAnalytics)

        XCTAssertEqual(subject.permissionState, .denied)
    }

    func test_trackEvent_rejectedPermissions_doesNothing() {
        let mockUserDefaults = UserDefaults()
        let subject = AnalyticsService(
            clients: [mockAnalyticsClient],
            userDefaults: mockUserDefaults
        )
        subject.setAcceptedAnalytics(accepted: false)

        subject.track(event: AppEvent.appLoaded)

        XCTAssertEqual(mockAnalyticsClient._trackEventReceivedEvents.count, 0)
    }

    func test_trackScreen_rejectedPermissions_doesNothing() {
        let mockUserDefaults = UserDefaults()
        let subject = AnalyticsService(
            clients: [mockAnalyticsClient],
            userDefaults: mockUserDefaults
        )
        subject.setAcceptedAnalytics(accepted: false)

        let mockViewController = MockBaseViewController()
        subject.track(screen: mockViewController)

        XCTAssertEqual(mockAnalyticsClient._trackEventReceivedEvents.count, 0)
    }

    func test_trackEvent_tracksEvents() {
        let mockUserDefaults = UserDefaults()
        let subject = AnalyticsService(
            clients: [mockAnalyticsClient],
            userDefaults: mockUserDefaults
        )
        subject.setAcceptedAnalytics(accepted: true)

        subject.track(event: AppEvent.appLoaded)

        XCTAssertEqual(mockAnalyticsClient._trackEventReceivedEvents.count, 1)
    }

    func test_trackScreen_tracksScreen() {
        let subject = AnalyticsService(
            clients: [mockAnalyticsClient],
            userDefaults: .standard
        )
        subject.setAcceptedAnalytics(accepted: true)

        let mockViewController = MockBaseViewController()
        subject.track(screen: mockViewController)

        let screens = mockAnalyticsClient._trackScreenReceivedScreens
        XCTAssertEqual(screens.count, 1)
        let screen = screens.first
        XCTAssertEqual(screen?.trackingName, mockViewController.trackingName)
        XCTAssertEqual(screen?.trackingClass, mockViewController.trackingClass)
        XCTAssertEqual(screen?.trackingTitle, mockViewController.trackingTitle)
        XCTAssertEqual(screen?.trackingLanguage, Locale.current.languageCode)
    }

    func test_setAcceptedAnalytics_true_grantsPermissions() {
        let mockUserDefaults = UserDefaults()
        let subject = AnalyticsService(
            clients: [mockAnalyticsClient],
            userDefaults: mockUserDefaults
        )
        subject.setAcceptedAnalytics(accepted: true)

        XCTAssertTrue(mockUserDefaults.bool(forKey: .acceptedAnalytics))
        XCTAssertEqual(mockAnalyticsClient._enabledReceived, true)
    }

    func test_setAcceptedAnalytics_false_denysPermission() {
        let mockUserDefaults = UserDefaults()
        let subject = AnalyticsService(
            clients: [mockAnalyticsClient],
            userDefaults: mockUserDefaults
        )

        subject.setAcceptedAnalytics(accepted: false)

        XCTAssertFalse(mockUserDefaults.bool(forKey: .acceptedAnalytics))
        XCTAssertEqual(mockAnalyticsClient._enabledReceived, false)
    }
}
