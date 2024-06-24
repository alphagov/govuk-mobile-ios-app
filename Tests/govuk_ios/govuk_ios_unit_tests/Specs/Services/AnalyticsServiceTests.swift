import UIKit
import Foundation
import XCTest
import Logging

@testable import govuk_ios

final class AnalyticsServiceTests: XCTestCase {
    let analyticsService = MockAnalyticsService()
    let analyticsPreferenceStore = MockAnalyticsPreferenceStore()
    
    func test_track_logsEvents() {
        let subject = AnalyticsService(
            analytics: analyticsService,
            preferenceStore: analyticsPreferenceStore
        )

        subject.track(event: AppEvent.appLoaded)
       
        XCTAssertTrue(analyticsService.eventsParamsLogged.count == 4)
    }
    
    func test_setAcceptedAnalytics_setsPreference() {
        let subject = AnalyticsService(
            analytics: analyticsService,
            preferenceStore: analyticsPreferenceStore
        )

        subject.setAcceptedAnalytics(accepted: true)
       
        XCTAssertTrue(analyticsPreferenceStore.hasAcceptedAnalytics == true)
    }
    
    func test_permissionState_returnsStatus() {
        let subject = AnalyticsService(
            analytics: analyticsService,
            preferenceStore: analyticsPreferenceStore
        )

        subject.setAcceptedAnalytics(accepted: false)
       
        XCTAssertTrue(subject.permissionState == .denied)
    }
}
