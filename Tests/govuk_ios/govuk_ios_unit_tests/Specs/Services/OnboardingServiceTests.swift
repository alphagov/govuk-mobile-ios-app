import UIKit
import Foundation
import XCTest

@testable import govuk_ios

final class OnboardingServiceTests: XCTestCase {
    func test_hasSeenOnboarding_hasSeen_returnsTrue() {
        let userDefaults = UserDefaults()
        userDefaults.set(bool: true, forKey: .appOnboardingSeen)
        let subject = OnboardingService(userDefaults: userDefaults)

        XCTAssertTrue(subject.hasSeenOnboarding)
    }

    func test_hasSeenOnboarding_hasntSeen_returnsTrue() {
        let userDefaults = UserDefaults()
        userDefaults.set(bool: false, forKey: .appOnboardingSeen)
        let subject = OnboardingService(userDefaults: userDefaults)

        XCTAssertFalse(subject.hasSeenOnboarding)
    }

    func test_setHasSeenOnboarding_setsTrue() {
        let userDefaults = UserDefaults()
        let subject = OnboardingService(userDefaults: userDefaults)
        subject.setHasSeenOnboarding()

        XCTAssertTrue(userDefaults.bool(forKey: .appOnboardingSeen))
    }

    func test_fetchSlides_returnsExpectedResult() {
        let subject = OnboardingService(userDefaults: .init())
        let result = subject.fetchSlides()

        XCTAssertEqual(result.count, 3)
    }

}
