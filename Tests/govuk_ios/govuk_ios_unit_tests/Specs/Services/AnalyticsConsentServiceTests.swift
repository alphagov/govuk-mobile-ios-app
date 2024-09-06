import UIKit
import Foundation
import XCTest

@testable import govuk_ios

final class AnalyticsConsentServiceTests: XCTestCase {
    func test_hasSeenAnalyticsConsent_hasSeen_returnsTrue() {
        let userDefaults = UserDefaults()
        userDefaults.set(bool: true, forkey: .appAnalyticsConsentSeen)
        let sut = AnalyticsConsentService(userDefaults: userDefaults)

        XCTAssertTrue(sut.hasSeenAnalyticsConsent)
    }

    func test_hasSeenAnalyticsConsent_hasntSeen_returnsTrue() {
        let userDefaults = UserDefaults()
        userDefaults.set(bool: false, forkey: .appAnalyticsConsentSeen)
        let sut = AnalyticsConsentService(userDefaults: userDefaults)

        XCTAssertFalse(sut.hasSeenAnalyticsConsent)
    }

    func test_setHasSeenAnalyticsConsent_setsTrue() {
        let userDefaults = UserDefaults()
        let sut = AnalyticsConsentService(userDefaults: userDefaults)
        sut.setHasSeenAnalyticsConsent()

        XCTAssertTrue(userDefaults.bool(forKey: .appAnalyticsConsentSeen))
    }
}
