import Foundation
import Testing
import SwiftUI
import CoreData
import Factory

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
            topicsService: MockTopicsService(),
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
        let coreData = CoreDataRepository.arrangeAndLoad
        Container.shared.coreDataRepository.register {
            coreData
        }
        let subject = ViewControllerBuilder()
        let result = subject.recentActivity(
            analyticsService: MockAnalyticsService()
        )

        let rootView = (result as? HostingViewController<ModifiedContent<RecentActivityContainerView, _EnvironmentKeyWritingModifier<NSManagedObjectContext>>>)?.rootView
        let containerView = rootView?.content as? RecentActivityContainerView
        #expect(containerView?.trackingClass == "RecentActivityContainerView")
        #expect(containerView?.trackingName == "Pages you've visited")
        #expect(containerView?.trackingTitle == "Pages you've visited")
    }
}
