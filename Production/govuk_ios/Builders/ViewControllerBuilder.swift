import Foundation
import UIKit
import SwiftUI
import Factory
import GOVKit
import RecentActivity
import SecureStore

class ViewControllerBuilder {
    @MainActor
    func launch(analyticsService: AnalyticsServiceInterface,
                completion: @escaping () -> Void) -> UIViewController {
        let viewModel = LaunchViewModel(
            animationCompleted: completion
        )
        return LaunchViewController(
            viewModel: viewModel,
            analyticsService: analyticsService
        )
    }

    struct HomeDependencies {
        let analyticsService: AnalyticsServiceInterface
        let configService: AppConfigServiceInterface
        let notificationService: NotificationServiceInterface
        let searchService: SearchServiceInterface
        let activityService: ActivityServiceInterface
        let topicWidgetViewModel: TopicsWidgetViewModel
    }

    struct HomeActions {
        let feedbackAction: () -> Void
        let notificationsAction: () -> Void
        let recentActivityAction: () -> Void
        let tokenAction: () -> Void
    }

    @MainActor
    func home(dependencies: HomeDependencies, actions: HomeActions) -> UIViewController {
        let viewModel = HomeViewModel(
            analyticsService: dependencies.analyticsService,
            configService: dependencies.configService,
            notificationService: dependencies.notificationService,
            topicWidgetViewModel: dependencies.topicWidgetViewModel,
            feedbackAction: actions.feedbackAction,
            notificationsAction: actions.notificationsAction,
            recentActivityAction: actions.recentActivityAction,
            tokenAction: actions.tokenAction,
            urlOpener: UIApplication.shared,
            searchService: dependencies.searchService,
            activityService: dependencies.activityService
        )
        return HomeViewController(
            viewModel: viewModel
        )
    }

    @MainActor
    func settings<T: SettingsViewModelInterface>(viewModel: T) -> UIViewController {
        let settingsContentView = SettingsView(
            viewModel: viewModel
        )

        let viewController = HostingViewController(
            rootView: settingsContentView,
            statusBarStyle: .darkContent
        )
        viewController.title = viewModel.title

        viewController.navigationItem.largeTitleDisplayMode = .always
        return viewController
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
        let viewController = HostingViewController(
            rootView: view
        )
        viewController.navigationItem.largeTitleDisplayMode =
        UINavigationItem.LargeTitleDisplayMode.never
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
        let viewController = HostingViewController(
            rootView: view
        )
        viewController.navigationItem.largeTitleDisplayMode =
        UINavigationItem.LargeTitleDisplayMode.never
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

    @MainActor
    func topicOnboarding(topics: [Topic],
                         analyticsService: AnalyticsServiceInterface,
                         topicsService: TopicsServiceInterface,
                         dismissAction: @escaping () -> Void) -> UIViewController {
        let viewModel = TopicOnboardingViewModel(
            topics: topics,
            analyticsService: analyticsService,
            topicsService: topicsService,
            dismissAction: dismissAction
        )
        return TopicOnboardingViewController(viewModel: viewModel)
    }

    @MainActor
    func tokenStore(secureStoreService: SecureStorable) -> UIViewController {
        let tokenView = TokenView(
            viewModel: TokenViewModel(
                secureStoreService: secureStoreService
            )
        )
        return HostingViewController(rootView: tokenView)
    }
}
