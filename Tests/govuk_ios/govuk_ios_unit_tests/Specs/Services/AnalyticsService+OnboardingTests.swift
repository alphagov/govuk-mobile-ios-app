import UIKit
import Foundation
import XCTest

@testable import Onboarding
@testable import govuk_ios

final class AnalyticsService_OnboardingTests: XCTestCase {
    var mockAnalyticsClient: MockAnalyticsClient!

    override func setUp() {
        mockAnalyticsClient = MockAnalyticsClient()
    }

    func test_trackOnboardingEvent_tracksEvents() {
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

        XCTAssertEqual(mockAnalyticsClient._trackEventReceivedEvents.count, 1)
        XCTAssertEqual(mockAnalyticsClient._trackEventReceivedEvents.first?.name, "test_name")
    }

    func test_trackOnboardingScreen_tracksEvents() {
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

        XCTAssertEqual(mockAnalyticsClient._trackScreenReceivedScreens.count, 1)
        XCTAssertEqual(mockAnalyticsClient._trackScreenReceivedScreens.first?.trackingName, "test_name")
        XCTAssertEqual(onboardingScreen.trackingLanguage, Locale.current.languageCode)
    }

}
