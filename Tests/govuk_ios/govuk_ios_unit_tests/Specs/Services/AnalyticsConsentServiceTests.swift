import UIKit
import Foundation
import XCTest

@testable import govuk_ios

final class AnalyticsConsentServiceTests: XCTestCase {
    func test_hasSeenAnalyticsConsent_hasSeen_returnsTrue() {
        let userDefaults = UserDefaults()
        userDefaults.set(bool: true, forkey: .appAnalyticsConsentSeen)
        let subject = AnalyticsConsentService(userDefaults: userDefaults)

        XCTAssertTrue(subject.hasSeenAnalyticsConsent)
    }

    func test_hasSeenAnalyticsConsent_hasntSeen_returnsTrue() {
        let userDefaults = UserDefaults()
        userDefaults.set(bool: false, forkey: .appAnalyticsConsentSeen)
        let subject = AnalyticsConsentService(userDefaults: userDefaults)

        XCTAssertFalse(subject.hasSeenAnalyticsConsent)
    }

    func test_setHasSeenAnalyticsConsent_setsTrue() {
        let userDefaults = UserDefaults()
        let subject = AnalyticsConsentService(userDefaults: userDefaults)
        subject.setHasSeenAnalyticsConsent()

        XCTAssertTrue(userDefaults.bool(forKey: .appAnalyticsConsentSeen))
    }
}
