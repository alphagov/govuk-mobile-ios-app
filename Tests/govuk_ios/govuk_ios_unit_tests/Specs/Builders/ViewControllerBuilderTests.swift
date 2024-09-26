import Foundation
import Testing

@testable import govuk_ios

@MainActor
@Suite
struct ViewControllerBuilderTests {
    @Test
    func driving_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let result = subject.driving(
            showPermitAction: {},
            presentPermitAction: {}
        )

        #expect(result is TestViewController)
        #expect(result.title == "Driving")
    }

    @Test
    func permit_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let result = subject.permit(
            permitId: "123",
            finishAction: {}
        )

        #expect(result is TestViewController)
        #expect(result.title == "Permit - 123")
    }

    @Test
    func home_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let result = subject.home(
            searchButtonPrimaryAction: { () -> Void in },
            configService: MockAppConfigService(),
            recentActivityAction: {}
        )

        #expect(result is HomeViewController)
    }

    @Test
    func settings_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let result = subject.settings(
            analyticsService: MockAnalyticsService()
        )

        #expect(result is SettingsViewController)
    }

    @Test
    func search_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let result = subject.search(
            analyticsService: MockAnalyticsService(),
            searchService: MockSearchService(),
            dismissAction: { }
        )

        #expect(result is SearchViewController)
    }

    @Test
    func recentActivity_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let _ = subject.recentActivity(
            analyticsService: MockAnalyticsService()
        )

//        let rootView = (result as? HostingViewController<RecentActivityContainerView>)?.rootView
//        #expect(rootView?.trackingClass == "RecentActivityContainerView")
//        #expect(rootView?.trackingName == "Pages you've visited")
//        #expect(rootView?.trackingTitle == "Pages you've visited")
    }
}
