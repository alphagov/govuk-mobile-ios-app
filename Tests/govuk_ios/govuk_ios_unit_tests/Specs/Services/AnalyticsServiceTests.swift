import UIKit
import Foundation
import XCTest
import Logging

@testable import govuk_ios

final class AnalyticsServiceTests: XCTestCase {
    let analyticsService = MockLoggingAnalyticsService()
    let analyticsPreferenceStore = MockAnalyticsPreferenceStore()
    
    func test_track_logsEvents() {
        let subject = AnalyticsService(
            analytics: analyticsService,
            preferenceStore: analyticsPreferenceStore
        )

        subject.track(event: AppEvent.appLoaded)
       
        XCTAssertEqual(analyticsService.eventsParamsLogged?.count, 1)
    }

    func test_trackScreen_logsScreen() {
        let subject = AnalyticsService(
            analytics: analyticsService,
            preferenceStore: analyticsPreferenceStore
        )

        subject.trackScreen(HomeScreen(name: "homescreen"))

        XCTAssertEqual(analyticsService.screensVisited.count, 1)
    }

    func test_setAcceptedAnalytics_setsPreference() {
        let subject = AnalyticsService(
            analytics: analyticsService,
            preferenceStore: analyticsPreferenceStore
        )

        subject.setAcceptedAnalytics(accepted: true)
       
        XCTAssertEqual(analyticsPreferenceStore.hasAcceptedAnalytics, true)
    }
    
    func test_permissionState_notSet_returnsUnknown() {
        let subject = AnalyticsService(
            analytics: analyticsService,
            preferenceStore: analyticsPreferenceStore
        )

        XCTAssertEqual(subject.permissionState, .unknown)
    }
    
    func test_permissionState_granted_returnsAccepted() {
        let subject = AnalyticsService(
            analytics: analyticsService,
            preferenceStore: analyticsPreferenceStore
        )
        
        subject.setAcceptedAnalytics(accepted: true)

        XCTAssertEqual(subject.permissionState, .accepted)
    }

    func test_permissionState_rejected_returnsDenied() {
        let subject = AnalyticsService(
            analytics: analyticsService,
            preferenceStore: analyticsPreferenceStore
        )

        subject.setAcceptedAnalytics(accepted: false)
       
        XCTAssertEqual(subject.permissionState, .denied)
    }
}
