import UIKit
import Foundation
import XCTest

import Factory

@testable import govuk_ios

class BaseViewControllerTests: XCTestCase {

    func test_preferredStatusBarStyle_returnsExpectedValue() {
        let subject = BaseViewController()
        XCTAssertEqual(subject.preferredStatusBarStyle, .lightContent)
    }

    func test_layoutMargins_returnsExpectedValue() {
        let subject = BaseViewController()
        let expectedInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        XCTAssertEqual(subject.view.layoutMargins, expectedInsets)
    }

    func test_viewDidAppear_notTrackable_doesntTrackScreen() {
        let mockAnalyticsService = MockAnalyticsService()
        Container.shared.analyticsService.register {
            mockAnalyticsService
        }
        let subject = BaseViewController()

        subject.viewDidAppear(false)

        XCTAssertEqual(mockAnalyticsService._trackScreenReceivedScreens.count, 0)
    }

    func test_viewDidAppear_trackableScreeb_tracksScreen() {
        let mockAnalyticsService = MockAnalyticsService()
        Container.shared.analyticsService.register {
            mockAnalyticsService
        }
        let subject = MockBaseViewController()

        subject.viewDidAppear(false)

        let screens = mockAnalyticsService._trackScreenReceivedScreens
        XCTAssertEqual(screens.count, 1)
        XCTAssertEqual(screens.first?.trackingName, subject.trackingName)
    }
}
