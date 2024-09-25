import Foundation
import XCTest

@testable import govuk_ios

@MainActor
class ViewControllerBuilderTests: XCTestCase {
    func test_driving_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let result = subject.driving(
            showPermitAction: {},
            presentPermitAction: {}
        )

        XCTAssert(result is TestViewController)
        XCTAssertEqual(result.title, "Driving")
    }

    func test_permit_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let result = subject.permit(
            permitId: "123",
            finishAction: {}
        )

        XCTAssert(result is TestViewController)
        XCTAssertEqual(result.title, "Permit - 123")
    }

    func test_home_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let result = subject.home(
            searchButtonPrimaryAction: { () -> Void in },
            configService: MockAppConfigService(), 
            recentActivityAction: {}
        )

        XCTAssert(result is HomeViewController)
    }

    func test_settings_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let result = subject.settings(
            analyticsService: MockAnalyticsService()
        )

        XCTAssert(result is SettingsViewController)
    }
    
    func test_search_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let result = subject.search(
            analyticsService: MockAnalyticsService(),
            searchService: MockSearchService(),
            dismissAction: { }
        )

        XCTAssert(result is SearchViewController)
    }
}
