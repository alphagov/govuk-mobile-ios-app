import UIKit
import Foundation
import XCTest

import Factory

@testable import govuk_ios

class HomeViewControllerTests: XCTestCase {
    
    @MainActor
    func test_viewDidAppear_tracksScreen() {
        let mockAnalyticsService = MockAnalyticsService()
        Container.shared.analyticsService.register {
            mockAnalyticsService
        }
        let viewModel = HomeViewModel(
            configService: MockAppConfigService(), 
            searchButtonPrimaryAction: { () -> Void in _ = true }, 
            recentActivityAction: { }
        )
        let subject = HomeViewController(viewModel: viewModel)
        subject.viewDidAppear(false)

        let screens = mockAnalyticsService._trackScreenReceivedScreens
        XCTAssertEqual(screens.count, 1)
        XCTAssertEqual(screens.first?.trackingName, subject.trackingName)
        XCTAssertEqual(screens.first?.trackingClass, subject.trackingClass)
    }
}
