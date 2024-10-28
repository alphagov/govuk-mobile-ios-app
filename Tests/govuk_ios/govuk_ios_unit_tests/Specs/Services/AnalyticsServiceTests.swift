import UIKit
import Foundation
import Testing

@testable import govuk_ios

@Suite
@MainActor
struct AnalyticsServiceTests {
    @Test
    func permissionState_notSet_returnsUnknown() {
        let mockAnalyticsClient = MockAnalyticsClient()
        let mockUserDefaults = UserDefaults()
        let subject = AnalyticsService(
            clients: [mockAnalyticsClient],
            userDefaults: mockUserDefaults
        )
        mockUserDefaults.setValue(nil, forKey: UserDefaultsKeys.acceptedAnalytics.rawValue)

        #expect(subject.permissionState == .unknown)
    }

    @Test
    func permissionState_accepted_returnsAccepted() {
        let mockAnalyticsClient = MockAnalyticsClient()
        let mockUserDefaults = UserDefaults()
        let subject = AnalyticsService(
            clients: [mockAnalyticsClient],
            userDefaults: mockUserDefaults
        )
        mockUserDefaults.set(bool: true, forKey: .acceptedAnalytics)

        #expect(subject.permissionState == .accepted)
    }

    @Test
    func permissionState_rejected_returnsDenied() {
        let mockAnalyticsClient = MockAnalyticsClient()
        let mockUserDefaults = UserDefaults()
        let subject = AnalyticsService(
            clients: [mockAnalyticsClient],
            userDefaults: mockUserDefaults
        )
        mockUserDefaults.set(bool: false, forKey: .acceptedAnalytics)

        #expect(subject.permissionState == .denied)
    }

    @Test
    func trackEvent_rejectedPermissions_doesNothing() {
        let mockAnalyticsClient = MockAnalyticsClient()
        let mockUserDefaults = UserDefaults()
        let subject = AnalyticsService(
            clients: [mockAnalyticsClient],
            userDefaults: mockUserDefaults
        )
        subject.setAcceptedAnalytics(accepted: false)

        subject.track(event: AppEvent.appLoaded)

        #expect(mockAnalyticsClient._trackEventReceivedEvents.count == 0)
    }

    @Test
    func trackScreen_rejectedPermissions_doesNothing() {
        let mockAnalyticsClient = MockAnalyticsClient()
        let mockUserDefaults = UserDefaults()
        let subject = AnalyticsService(
            clients: [mockAnalyticsClient],
            userDefaults: mockUserDefaults
        )
        subject.setAcceptedAnalytics(accepted: false)

        let mockViewController = MockBaseViewController()
        subject.track(screen: mockViewController)

        #expect(mockAnalyticsClient._trackEventReceivedEvents.count == 0)
    }

    @Test
    func trackEvent_tracksEvents() {
        let mockAnalyticsClient = MockAnalyticsClient()
        let mockUserDefaults = UserDefaults()
        let subject = AnalyticsService(
            clients: [mockAnalyticsClient],
            userDefaults: mockUserDefaults
        )
        subject.setAcceptedAnalytics(accepted: true)

        subject.track(event: AppEvent.appLoaded)

        #expect(mockAnalyticsClient._trackEventReceivedEvents.count == 1)
    }

    @Test
    func trackScreen_tracksScreen() {
        let mockAnalyticsClient = MockAnalyticsClient()
        let subject = AnalyticsService(
            clients: [mockAnalyticsClient],
            userDefaults: UserDefaults()
        )
        subject.setAcceptedAnalytics(accepted: true)

        let mockViewController = MockBaseViewController()
        subject.track(screen: mockViewController)

        let screens = mockAnalyticsClient._trackScreenReceivedScreens
        #expect(screens.count == 1)
        let screen = screens.first
        #expect(screen?.trackingName == mockViewController.trackingName)
        #expect(screen?.trackingClass == mockViewController.trackingClass)
        #expect(screen?.trackingTitle == mockViewController.trackingTitle)
        if #available(iOS 16, *) {
            #expect(screen?.trackingLanguage == Locale.current.language.languageCode?.identifier)
        }
    }

    @Test
    func setAcceptedAnalytics_true_grantsPermissions() {
        let mockAnalyticsClient = MockAnalyticsClient()
        let mockUserDefaults = UserDefaults()
        let subject = AnalyticsService(
            clients: [mockAnalyticsClient],
            userDefaults: mockUserDefaults
        )
        subject.setAcceptedAnalytics(accepted: true)

        #expect(mockUserDefaults.bool(forKey: .acceptedAnalytics) == true)
        #expect(mockAnalyticsClient._enabledReceived == true)
    }

    @Test
    func setAcceptedAnalytics_false_denysPermission() {
        let mockAnalyticsClient = MockAnalyticsClient()
        let mockUserDefaults = UserDefaults()
        let subject = AnalyticsService(
            clients: [mockAnalyticsClient],
            userDefaults: mockUserDefaults
        )

        subject.setAcceptedAnalytics(accepted: false)

        #expect(mockUserDefaults.bool(forKey: .acceptedAnalytics) == false)
        #expect(mockAnalyticsClient._enabledReceived == false)
    }
}
