import Foundation
import UIKit
import Testing

import Factory

@testable import govuk_ios

@Suite
@MainActor
struct BaseViewControllerTests {
    @Test
    func layoutMargins_returnsExpectedValue() {
        let subject = BaseViewController()
        let expectedInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        #expect(subject.view.layoutMargins == expectedInsets)
    }

    @Test
    func viewDidAppear_notTrackable_doesntTrackScreen() {
        let mockAnalyticsService = MockAnalyticsService()
        Container.shared.analyticsService.register {
            mockAnalyticsService
        }
        let subject = BaseViewController()

        subject.beginAppearanceTransition(true, animated: true)
        subject.endAppearanceTransition()

        #expect(mockAnalyticsService._trackScreenReceivedScreens.count == 0)
    }

    @Test
    func viewDidAppear_trackableScreen_tracksScreen() {
        let mockAnalyticsService = MockAnalyticsService()
        Container.shared.analyticsService.register {
            mockAnalyticsService
        }
        let subject = MockBaseViewController()
        subject.beginAppearanceTransition(true, animated: true)
        subject.endAppearanceTransition()

        let screens = mockAnalyticsService._trackScreenReceivedScreens
        #expect(screens.count == 1)
        #expect(screens.first?.trackingName == subject.trackingName)
    }
}
