import Foundation
import UIKit
import Testing

@testable import GOVKit

@Suite
@MainActor
struct BaseViewControllerTests {
    @Test
    func layoutMargins_returnsExpectedValue() {
        let mockAnalyticsService = MockAnalyticsService()
        let subject = BaseViewController(
            analyticsService: mockAnalyticsService
        )
        let expectedInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        #expect(subject.view.layoutMargins == expectedInsets)
    }

    @Test
    func viewDidAppear_notTrackable_doesntTrackScreen() {
        let mockAnalyticsService = MockAnalyticsService()
        let subject = BaseViewController(
            analyticsService: mockAnalyticsService
        )

        subject.beginAppearanceTransition(true, animated: true)
        subject.endAppearanceTransition()

        #expect(mockAnalyticsService._trackScreenReceivedScreens.count == 0)
    }

    @Test
    @MainActor
    func viewDidAppear_trackableScreen_tracksScreen() {
        let mockAnalyticsService = MockAnalyticsService()
        let subject = MockBaseViewController(
            analyticsService: mockAnalyticsService
        )
        subject.beginAppearanceTransition(true, animated: true)
        subject.endAppearanceTransition()

        let screens = mockAnalyticsService._trackScreenReceivedScreens
        #expect(screens.count == 1)
        #expect(screens.first?.trackingName == subject.trackingName)
    }
}
