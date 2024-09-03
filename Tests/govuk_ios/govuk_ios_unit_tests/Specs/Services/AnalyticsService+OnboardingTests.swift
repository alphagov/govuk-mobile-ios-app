import UIKit
import Foundation
import XCTest
import Logging

@testable import Onboarding
@testable import govuk_ios

final class AnalyticsService_OnboardingTests: XCTestCase {
    let mockLoggingAnalyticsService = MockLoggingAnalyticsService()
    let mockAnalyticsPreferenceStore = MockAnalyticsPreferenceStore()

    func test_trackOnboardingEvent_tracksEvents() {
        let subject = AnalyticsService(
            analytics: mockLoggingAnalyticsService,
            preferenceStore: mockAnalyticsPreferenceStore
        )

        let event = OnboardingEvent(
            name: "test_name",
            type: "test_type",
            text: "test_text"
        )
        subject.trackOnboardingEvent(event)

        XCTAssertEqual(mockLoggingAnalyticsService.eventsLogged.count, 1)
        XCTAssertEqual(mockLoggingAnalyticsService.eventsLogged.first, "test_name")
    }

    func test_trackOnboardingScreen_tracksEvents() {
        let subject = AnalyticsService(
            analytics: mockLoggingAnalyticsService,
            preferenceStore: mockAnalyticsPreferenceStore
        )
        let onboardingScreen = OnboardingScreen(
            trackingName: "test_name",
            trackingClass: "test_class",
            trackingTitle: "test_title"
        )
        subject.trackOnboardingScreen(onboardingScreen)

        XCTAssertEqual(mockLoggingAnalyticsService._trackScreenV2ReceivedScreens.count, 1)
        XCTAssertEqual(mockLoggingAnalyticsService._trackScreenV2ReceivedScreens.first?.name, "test_name")
    }

}
