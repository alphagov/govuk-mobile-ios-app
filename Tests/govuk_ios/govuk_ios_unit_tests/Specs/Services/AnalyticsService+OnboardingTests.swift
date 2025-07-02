import UIKit
import Foundation
import Testing

@testable import Onboarding
@testable import GOVKitTestUtilities
@testable import govuk_ios

@Suite
struct AnalyticsService_OnboardingTests {
    @Test
    func trackOnboardingEvent_tracksEvents() {
        let mockAnalyticsClient = MockAnalyticsClient()
        let subject = AnalyticsService(
            clients: [mockAnalyticsClient],
            userDefaults: UserDefaults()
        )
        subject.setAcceptedAnalytics(accepted: true)
        let event = OnboardingEvent(
            name: "test_name",
            type: "test_type",
            text: "test_text"
        )
        subject.trackOnboardingEvent(event)

        #expect(mockAnalyticsClient._trackEventReceivedEvents.count == 1)
        #expect(mockAnalyticsClient._trackEventReceivedEvents.first?.name == "test_name")
    }

    @Test
    func trackOnboardingScreen_tracksEvents() {
        let mockAnalyticsClient = MockAnalyticsClient()
        let subject = AnalyticsService(
            clients: [mockAnalyticsClient],
            userDefaults: UserDefaults()
        )
        subject.setAcceptedAnalytics(accepted: true)
        let onboardingScreen = OnboardingScreen(
            trackingName: "test_name",
            trackingClass: "test_class",
            trackingTitle: "test_title"
        )
        subject.trackOnboardingScreen(onboardingScreen)

        #expect(mockAnalyticsClient._trackScreenReceivedScreens.count == 1)
        #expect(mockAnalyticsClient._trackScreenReceivedScreens.first?.trackingName == "test_name")
        #expect(onboardingScreen.trackingLanguage == Locale.current.language.languageCode?.identifier)
    }

}
