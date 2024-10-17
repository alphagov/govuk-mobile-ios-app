import Foundation
import UIKit
import SwiftUI
import Factory

class ViewControllerBuilder {
    @MainActor
    func driving(showPermitAction: @escaping () -> Void,
                 presentPermitAction: @escaping () -> Void) -> UIViewController {
        let viewModel = TestViewModel(
            color: .cyan,
            tabTitle: "Driving",
            primaryTitle: "Push Permit",
            primaryAction: showPermitAction,
            secondaryTitle: "Modal Permit",
            secondaryAction: presentPermitAction
        )
        return TestViewController(
            viewModel: viewModel
        )
    }

    @MainActor
    func launch(completion: @escaping () -> Void) -> UIViewController {
        let viewModel = LaunchViewModel(
            animationCompleted: completion
        )
        return LaunchViewController(
            viewModel: viewModel
        )
    }

    @MainActor
    func permit(permitId: String,
                finishAction: @escaping () -> Void) -> UIViewController {
        let viewModel = TestViewModel(
            color: .lightGray,
            tabTitle: "Permit - \(permitId)",
            primaryTitle: nil,
            primaryAction: nil,
            secondaryTitle: "Dismiss",
            secondaryAction: finishAction
        )
        return TestViewController(
            viewModel: viewModel
        )
    }

    @MainActor
    func home(searchButtonPrimaryAction: @escaping () -> Void,
              configService: AppConfigServiceInterface,
              recentActivityAction: @escaping () -> Void,
              topicWidgetViewModel: TopicsWidgetViewModel) -> UIViewController {
        let viewModel = HomeViewModel(
            configService: configService,
            searchButtonPrimaryAction: searchButtonPrimaryAction,
            recentActivityAction: recentActivityAction,
            topicWidgetViewModel: topicWidgetViewModel
        )
        return HomeViewController(
            viewModel: viewModel
        )
    }

    @MainActor
    func settings(analyticsService: AnalyticsServiceInterface) -> UIViewController {
        let viewModel = SettingsViewModel(
            analyticsService: analyticsService,
            urlOpener: UIApplication.shared,
            bundle: .main
        )
        return SettingsViewController(
            viewModel: viewModel
        )
    }

    @MainActor
    func search(analyticsService: AnalyticsServiceInterface,
                searchService: SearchServiceInterface,
                dismissAction: @escaping () -> Void) -> UIViewController {
        let viewModel = SearchViewModel(
            analyticsService: analyticsService,
            searchService: searchService,
            activityService: Container.shared.activityService.resolve(),
            urlOpener: UIApplication.shared
        )
        return SearchViewController(
            viewModel: viewModel,
            dismissAction: dismissAction
        )
    }

    @MainActor
    func recentActivity(analyticsService: AnalyticsServiceInterface,
                        activityService: ActivityServiceInterface) -> UIViewController {
        let viewModel = RecentActivityListViewModel(
            activityService: activityService,
            analyticsService: analyticsService,
            urlopener: UIApplication.shared
        )
        return RecentActivityListViewController(
            viewModel: viewModel
        )
    }

    @MainActor
    func topicDetail(topic: DisplayableTopic,
                     topicsService: TopicsServiceInterface,
                     analyticsService: AnalyticsServiceInterface,
                     navigationAction: @escaping (DisplayableTopic) -> Void
    ) -> UIViewController {
        let viewModel = TopicDetailViewModel(
            topic: topic,
            topicsService: topicsService,
            analyticsService: analyticsService,
            urlOpener: UIApplication.shared,
            navigationAction: navigationAction
        )

        let view = TopicDetailView(viewModel: viewModel)

        return HostingViewController(rootView: view)
    }

    @MainActor
    func editTopics(_ topics: [Topic],
                    analyticsService: AnalyticsServiceInterface,
                    topicsService: TopicsServiceInterface,
                    dismissAction: @escaping () -> Void) -> UIViewController {
        let viewModel = EditTopicsViewModel(
            topics: topics,
            topicsService: topicsService,
            analyticsService: analyticsService,
            dismissAction: dismissAction
        )

        let view = EditTopicsView(
            viewModel: viewModel
        )
        return HostingViewController(rootView: view)
    }
}
