import UIKit
import Foundation
import Testing
import GOVKit

@testable import GOVKitTestUtilities
@testable import govuk_ios

@Suite
@MainActor
struct AnalyticsServiceTests {
    @Test
    func init_configuresDisabled() {
        let mockAnalyticsClient = MockAnalyticsClient()
        let mockUserDefaults = MockUserDefaults()
        let mockAuthenticationService = MockAuthenticationService()

        mockAnalyticsClient._enabledReceived = true
        _ = AnalyticsService(
            clients: [mockAnalyticsClient],
            userDefaults: mockUserDefaults,
            authenticationService: mockAuthenticationService
        )

        #expect(mockAnalyticsClient._enabledReceived == false)
    }

    @Test
    func permissionState_notSet_returnsUnknown() {
        let mockAnalyticsClient = MockAnalyticsClient()
        let mockUserDefaults = MockUserDefaults()
        let mockAuthenticationService = MockAuthenticationService()
        let subject = AnalyticsService(
            clients: [mockAnalyticsClient],
            userDefaults: mockUserDefaults,
            authenticationService: mockAuthenticationService
        )
        mockUserDefaults._stub(
            value: nil,
            key: UserDefaultsKeys.acceptedAnalytics.rawValue
        )

        #expect(subject.permissionState == .unknown)
    }

    @Test
    func permissionState_accepted_returnsAccepted() {
        let mockAnalyticsClient = MockAnalyticsClient()
        let mockUserDefaults = MockUserDefaults()
        let mockAuthenticationService = MockAuthenticationService()
        let subject = AnalyticsService(
            clients: [mockAnalyticsClient],
            userDefaults: mockUserDefaults,
            authenticationService: mockAuthenticationService
        )
        mockUserDefaults._stub(
            value: true,
            key: UserDefaultsKeys.acceptedAnalytics.rawValue
        )

        #expect(subject.permissionState == .accepted)
    }

    @Test
    func permissionState_rejected_returnsDenied() {
        let mockAnalyticsClient = MockAnalyticsClient()
        let mockUserDefaults = MockUserDefaults()
        let mockAuthenticationService = MockAuthenticationService()
        let subject = AnalyticsService(
            clients: [mockAnalyticsClient],
            userDefaults: mockUserDefaults,
            authenticationService: mockAuthenticationService
        )
        mockUserDefaults._stub(
            value: false,
            key: UserDefaultsKeys.acceptedAnalytics.rawValue
        )

        #expect(subject.permissionState == .denied)
    }

    @Test
    func trackEvent_rejectedPermissions_doesNothing() {
        let mockAnalyticsClient = MockAnalyticsClient()
        let mockUserDefaults = MockUserDefaults()
        let mockAuthenticationService = MockAuthenticationService()
        mockAuthenticationService._stubbedIsSignedIn = true
        let subject = AnalyticsService(
            clients: [mockAnalyticsClient],
            userDefaults: mockUserDefaults,
            authenticationService: mockAuthenticationService
        )
        subject.setAcceptedAnalytics(accepted: false)

        subject.track(event: AppEvent.appLoaded)

        #expect(mockAnalyticsClient._trackEventReceivedEvents.count == 0)
    }

    @Test
    @MainActor
    func trackScreen_rejectedPermissions_doesNothing() {
        let mockAnalyticsClient = MockAnalyticsClient()
        let mockUserDefaults = MockUserDefaults()
        let mockAuthenticationService = MockAuthenticationService()
        mockAuthenticationService._stubbedIsSignedIn = true
        let subject = AnalyticsService(
            clients: [mockAnalyticsClient],
            userDefaults: mockUserDefaults,
            authenticationService: mockAuthenticationService
        )
        subject.setAcceptedAnalytics(accepted: false)

        let mockViewController = MockBaseViewController(
            analyticsService: subject
        )
        subject.track(screen: mockViewController)

        #expect(mockAnalyticsClient._trackEventReceivedEvents.count == 0)
    }

    @Test
    func trackEvent_signedOut_doesNothing() {
        let mockAnalyticsClient = MockAnalyticsClient()
        let mockUserDefaults = MockUserDefaults()
        let mockAuthenticationService = MockAuthenticationService()
        mockAuthenticationService._stubbedIsSignedIn = false
        let subject = AnalyticsService(
            clients: [mockAnalyticsClient],
            userDefaults: mockUserDefaults,
            authenticationService: mockAuthenticationService
        )
        subject.setAcceptedAnalytics(accepted: true)

        subject.track(event: AppEvent.appLoaded)

        #expect(mockAnalyticsClient._trackEventReceivedEvents.count == 0)
    }

    @Test
    @MainActor
    func trackScreen_signedOut_doesNothing() {
        let mockAnalyticsClient = MockAnalyticsClient()
        let mockUserDefaults = MockUserDefaults()
        let mockAuthenticationService = MockAuthenticationService()
        mockAuthenticationService._stubbedIsSignedIn = true
        let subject = AnalyticsService(
            clients: [mockAnalyticsClient],
            userDefaults: mockUserDefaults,
            authenticationService: mockAuthenticationService
        )
        subject.setAcceptedAnalytics(accepted: true)

        let mockViewController = MockBaseViewController(
            analyticsService: subject
        )
        subject.track(screen: mockViewController)

        #expect(mockAnalyticsClient._trackEventReceivedEvents.count == 0)
    }

    @Test
    func trackEvent_tracksEvents() {
        let mockAnalyticsClient = MockAnalyticsClient()
        let mockUserDefaults = MockUserDefaults()
        let mockAuthenticationService = MockAuthenticationService()
        mockAuthenticationService._stubbedIsSignedIn = true
        let subject = AnalyticsService(
            clients: [mockAnalyticsClient],
            userDefaults: mockUserDefaults,
            authenticationService: mockAuthenticationService
        )
        subject.setAcceptedAnalytics(accepted: true)

        subject.track(event: AppEvent.appLoaded)

        #expect(mockAnalyticsClient._trackEventReceivedEvents.count == 1)
    }

    @Test
    @MainActor
    func trackScreen_tracksScreen() {
        let mockAnalyticsClient = MockAnalyticsClient()
        let mockUserDefaults = MockUserDefaults()
        let mockAuthenticationService = MockAuthenticationService()
        mockAuthenticationService._stubbedIsSignedIn = true
        let subject = AnalyticsService(
            clients: [mockAnalyticsClient],
            userDefaults: mockUserDefaults,
            authenticationService: mockAuthenticationService
        )
        subject.setAcceptedAnalytics(accepted: true)

        let mockViewController = MockBaseViewController(
            analyticsService: subject
        )
        subject.track(screen: mockViewController)

        let screens = mockAnalyticsClient._trackScreenReceivedScreens
        #expect(screens.count == 1)
        let screen = screens.first
        #expect(screen?.trackingName == mockViewController.trackingName)
        #expect(screen?.trackingClass == mockViewController.trackingClass)
        #expect(screen?.trackingTitle == mockViewController.trackingTitle)
        #expect(screen?.additionalParameters.count == mockViewController.additionalParameters.count)
        #expect(screen?.trackingLanguage == Locale.current.language.languageCode?.identifier)
    }

    @Test
    func setAcceptedAnalytics_true_grantsPermissions() {
        let mockAnalyticsClient = MockAnalyticsClient()
        let mockUserDefaults = MockUserDefaults()
        let mockAuthenticationService = MockAuthenticationService()
        let subject = AnalyticsService(
            clients: [mockAnalyticsClient],
            userDefaults: mockUserDefaults,
            authenticationService: mockAuthenticationService
        )
        subject.setAcceptedAnalytics(accepted: true)

        #expect(mockUserDefaults.bool(forKey: .acceptedAnalytics) == true)
        #expect(mockAnalyticsClient._enabledReceived == true)
    }

    @Test
    func setAcceptedAnalytics_false_denysPermission() {
        let mockAnalyticsClient = MockAnalyticsClient()
        let mockUserDefaults = MockUserDefaults()
        let mockAuthenticationService = MockAuthenticationService()
        let subject = AnalyticsService(
            clients: [mockAnalyticsClient],
            userDefaults: mockUserDefaults,
            authenticationService: mockAuthenticationService
        )

        subject.setAcceptedAnalytics(accepted: false)

        #expect(mockUserDefaults.bool(forKey: .acceptedAnalytics) == false)
        #expect(mockAnalyticsClient._enabledReceived == false)
    }

    @Test
    func setUserProperty_tracksProperty() {
        let mockAnalyticsClient = MockAnalyticsClient()
        let mockUserDefaults = MockUserDefaults()
        let mockAuthenticationService = MockAuthenticationService()
        let subject = AnalyticsService(
            clients: [mockAnalyticsClient],
            userDefaults: mockUserDefaults,
            authenticationService: mockAuthenticationService
        )

        let expectedKey = UUID().uuidString
        let expectedValue = UUID().uuidString
        subject.set(
            userProperty: .init(key: expectedKey, value: expectedValue)
        )

        #expect(mockAnalyticsClient._trackSetUserPropertyReceivedProperty?.key == expectedKey)
        #expect(mockAnalyticsClient._trackSetUserPropertyReceivedProperty?.value == expectedValue)
    }

    @Test
    func resetConsent_removesConsent() {
        let mockAnalyticsClient = MockAnalyticsClient()
        let mockUserDefaults = MockUserDefaults()
        let mockAuthenticationService = MockAuthenticationService()
        let subject = AnalyticsService(
            clients: [mockAnalyticsClient],
            userDefaults: mockUserDefaults,
            authenticationService: mockAuthenticationService
        )

        mockUserDefaults._stub(value: true, key: UserDefaultsKeys.acceptedAnalytics.rawValue)

        subject.resetConsent()

        #expect(mockUserDefaults.value(forKey: .acceptedAnalytics) == nil)
    }

    @Test
    func setExistingConsent_accepted_grantsPermission() {
        let mockAnalyticsClient = MockAnalyticsClient()
        let mockUserDefaults = MockUserDefaults()
        let mockAuthenticationService = MockAuthenticationService()
        let subject = AnalyticsService(
            clients: [mockAnalyticsClient],
            userDefaults: mockUserDefaults,
            authenticationService: mockAuthenticationService
        )

        mockUserDefaults._stub(value: true, key: UserDefaultsKeys.acceptedAnalytics.rawValue)

        subject.setExistingConsent()

        #expect(mockAnalyticsClient._enabledReceived == true)
    }

    @Test
    func setExistingConsent_denied_denysPermission() {
        let mockAnalyticsClient = MockAnalyticsClient()
        let mockUserDefaults = MockUserDefaults()
        let mockAuthenticationService = MockAuthenticationService()
        let subject = AnalyticsService(
            clients: [mockAnalyticsClient],
            userDefaults: mockUserDefaults,
            authenticationService: mockAuthenticationService
        )

        mockUserDefaults._stub(value: false, key: UserDefaultsKeys.acceptedAnalytics.rawValue)

        subject.setExistingConsent()

        #expect(mockAnalyticsClient._enabledReceived == false)
    }

    @Test
    func setExistingConsent_unknown_doesntAlterPermission() {
        let mockAnalyticsClient = MockAnalyticsClient()
        let mockUserDefaults = MockUserDefaults()
        let mockAuthenticationService = MockAuthenticationService()
        let subject = AnalyticsService(
            clients: [mockAnalyticsClient],
            userDefaults: mockUserDefaults,
            authenticationService: mockAuthenticationService
        )

        mockUserDefaults._stub(value: nil, key: UserDefaultsKeys.acceptedAnalytics.rawValue)

        subject.setExistingConsent()

        #expect(mockAnalyticsClient._enabledReceived == false)
    }
}
