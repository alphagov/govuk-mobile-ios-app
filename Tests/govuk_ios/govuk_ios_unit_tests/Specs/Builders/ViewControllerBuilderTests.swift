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
        let viewModel = TopicsWidgetViewModel(
            topicsService: MockTopicsService(),
            topicAction: { _ in },
            editAction: { },
            allTopicsAction: { }
        )
        let result = subject.home(
            analyticsService: MockAnalyticsService(),
            configService: MockAppConfigService(),
            topicWidgetViewModel: viewModel,
            searchAction: { () -> Void in },
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
            analyticsService: MockAnalyticsService(),
            activityService: MockActivityService()
        ) as? TrackableScreen

        #expect(result?.trackingClass == String(describing: RecentActivityListViewController.self))
        #expect(result?.trackingName == "Pages you've visited")
        #expect(result?.trackingTitle == "Pages you've visited")
    }
    
    @Test
    func topicDetail_returnsExpectedResult() async throws {
        let subject = ViewControllerBuilder()
        let result = subject.topicDetail(
            topic: MockDisplayableTopic(ref: "", title: ""),
            topicsService: MockTopicsService(),
            analyticsService: MockAnalyticsService(),
            activityService: MockActivityService(),
            subtopicAction: { _ in },
            stepByStepAction: { _ in }
        )
        
        let rootView = (result as? HostingViewController<TopicDetailView<TopicDetailViewModel>>)?.rootView
        #expect(rootView != nil)
    }

    @Test
    func editTopics_returnsExpectedResult() async throws {
        let subject = ViewControllerBuilder()
        let result = subject.editTopics(
            analyticsService: MockAnalyticsService(),
            topicsService: MockTopicsService(),
            dismissAction: { }
        )
        
        let rootView = (result as? HostingViewController<EditTopicsView>)?.rootView
        #expect(rootView != nil)
    }

    @Test
    func allTopics_returnsExpectedResult() async throws {
        let subject = ViewControllerBuilder()
        let result = subject.allTopics(
            analyticsService: MockAnalyticsService(),
            topicAction: { _ in },
            topicsService: MockTopicsService()
        )

        #expect(result is AllTopicsViewController)
    }
}
