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
    func home(analyticsService: AnalyticsServiceInterface,
              configService: AppConfigServiceInterface,
              topicWidgetViewModel: TopicsWidgetViewModel,
              searchAction: @escaping () -> Void,
              recentActivityAction: @escaping () -> Void) -> UIViewController {
        let viewModel = HomeViewModel(
            analyticsService: analyticsService,
            configService: configService,
            topicWidgetViewModel: topicWidgetViewModel,
            searchAction: searchAction,
            recentActivityAction: recentActivityAction
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
        let settingsContentView = SettingsView(
            viewModel: viewModel
        )

        let viewController = HostingViewController(rootView: settingsContentView)
        viewController.title = viewModel.title
        viewController.navigationItem.largeTitleDisplayMode = .always
        return viewController
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
    // swiftlint:disable:next function_parameter_count
    func topicDetail(topic: DisplayableTopic,
                     topicsService: TopicsServiceInterface,
                     analyticsService: AnalyticsServiceInterface,
                     activityService: ActivityServiceInterface,
                     subtopicAction: @escaping (DisplayableTopic) -> Void,
                     stepByStepAction: @escaping ([TopicDetailResponse.Content]) -> Void
    ) -> UIViewController {
        let viewModel = TopicDetailViewModel(
            topic: topic,
            topicsService: topicsService,
            analyticsService: analyticsService,
            activityService: activityService,
            urlOpener: UIApplication.shared,
            subtopicAction: subtopicAction,
            stepByStepAction: stepByStepAction
        )

        let view = TopicDetailView(viewModel: viewModel)
        let viewController = HostingViewController(rootView: view)
        viewController.title = viewModel.title
        viewController.navigationItem.largeTitleDisplayMode = .always
        viewController.navigationItem.backButtonTitle = viewModel.title
        return viewController
    }

    @MainActor
    func stepByStep(content: [TopicDetailResponse.Content],
                    analyticsService: AnalyticsServiceInterface,
                    activityService: ActivityServiceInterface) -> UIViewController {
        let viewModel = StepByStepsViewModel(
            content: content,
            analyticsService: analyticsService,
            activityService: activityService,
            urlOpener: UIApplication.shared
        )
        let view = TopicDetailView(viewModel: viewModel)
        let viewController = HostingViewController(rootView: view)
        viewController.title = viewModel.title
        viewController.navigationItem.largeTitleDisplayMode = .never
        return viewController
    }

    @MainActor
    func allTopics(analyticsService: AnalyticsServiceInterface,
                   topicAction: @escaping (Topic) -> Void,
                   topicsService: TopicsServiceInterface) -> UIViewController {
        let viewModel = AllTopicsViewModel(
            analyticsService: analyticsService,
            topicAction: topicAction,
            topicsService: topicsService
        )
        return AllTopicsViewController(
            viewModel: viewModel
        )
    }

    @MainActor
    func editTopics(analyticsService: AnalyticsServiceInterface,
                    topicsService: TopicsServiceInterface,
                    dismissAction: @escaping () -> Void) -> UIViewController {
        let viewModel = EditTopicsViewModel(
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
