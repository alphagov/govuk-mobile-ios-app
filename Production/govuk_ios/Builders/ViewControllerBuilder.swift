import Foundation
import UIKit
import SwiftUI
import Factory
import GOVKit
import SafariServices

// swiftlint:disable:next type_body_length
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
        let localAuthorityService: LocalAuthorityServiceInterface
    }

    struct HomeActions {
        let feedbackAction: () -> Void
        let notificationsAction: () -> Void
        let recentActivityAction: () -> Void
        let localAuthorityAction: () -> Void
        let editLocalAuthorityAction: () -> Void
        let openSearchAction: (SearchItem) -> Void
    }

    @MainActor
    func home(dependencies: HomeDependencies,
              actions: HomeActions) -> UIViewController {
        let viewModel = HomeViewModel(
            analyticsService: dependencies.analyticsService,
            configService: dependencies.configService,
            notificationService: dependencies.notificationService,
            topicWidgetViewModel: dependencies.topicWidgetViewModel,
            localAuthorityAction: actions.localAuthorityAction,
            editLocalAuthorityAction: actions.editLocalAuthorityAction,
            feedbackAction: actions.feedbackAction,
            notificationsAction: actions.notificationsAction,
            recentActivityAction: actions.recentActivityAction,
            openAction: actions.openSearchAction,
            urlOpener: UIApplication.shared,
            searchService: dependencies.searchService,
            activityService: dependencies.activityService,
            localAuthorityService: dependencies.localAuthorityService
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
                        activityService: ActivityServiceInterface,
                        selectedAction: @escaping (URL) -> Void) -> UIViewController {
        let viewModel = RecentActivityListViewModel(
            activityService: activityService,
            analyticsService: analyticsService,
            selectedAction: selectedAction
        )
        return RecentActivityListViewController(
            viewModel: viewModel
        )
    }

    @MainActor
    func localAuthorityExplainerView(analyticsService: AnalyticsServiceInterface,
                                     navigateToPostCodeEntryViewAction: @escaping () -> Void,
                                     dismissAction: @escaping () -> Void) -> UIViewController {
        let viewModel = LocalAuthorityExplainerViewModel(
            analyticsService: analyticsService,
            navigateToPostcodeEntry: navigateToPostCodeEntryViewAction,
            dismissAction: dismissAction
        )
        let view = LocalAuthorityExplainerView(
            viewModel: viewModel
        )
        return HostingViewController(rootView: view)
    }

    @MainActor
    func localAuthorityPostcodeEntryView(
        analyticsService: AnalyticsServiceInterface,
        localAuthorityService: LocalAuthorityServiceInterface,
        resolveAmbiguityAction: @escaping (AmbiguousAuthorities, String) -> Void,
        navigateToConfirmationView: @escaping (Authority) -> Void,
        dismissAction: @escaping () -> Void
    ) -> UIViewController {
        let viewModel = LocalAuthorityPostcodeEntryViewModel(
            service: localAuthorityService,
            analyticsService: analyticsService,
            resolveAmbiguityAction: resolveAmbiguityAction,
            navigateToConfirmationView: navigateToConfirmationView,
            dismissAction: dismissAction
        )
        let view = LocalAuthorityPostcodeEntryView(
            viewModel: viewModel
        )
        return HostingViewController(rootView: view)
    }

    // swiftlint:disable:next function_parameter_count
    func ambiguousAuthoritySelectionView(
        analyticsService: AnalyticsServiceInterface,
        localAuthorityService: LocalAuthorityServiceInterface,
        localAuthorities: AmbiguousAuthorities,
        postCode: String,
        navigateToConfirmationView: @escaping (Authority) -> Void,
        selectAddressAction: @escaping () -> Void,
        dismissAction: @escaping () -> Void
    ) -> UIViewController {
        let viewModel = AmbiguousAuthoritySelectionViewModel(
            analyticsService: analyticsService,
            localAuthorityService: localAuthorityService,
            ambiguousAuthorities: localAuthorities,
            postCode: postCode,
            navigateToConfirmationView: navigateToConfirmationView,
            selectAddressAction: selectAddressAction,
            dismissAction: dismissAction
        )
        let view = AmbiguousAuthoritySelectionView(
            viewModel: viewModel
        )
        return HostingViewController(rootView: view)
    }

    func ambiguousAddressSelectionView(
        analyticsService: AnalyticsServiceInterface,
        localAuthorityService: LocalAuthorityServiceInterface,
        localAuthorities: AmbiguousAuthorities,
        navigateToConfirmationView: @escaping (Authority) -> Void,
        dismissAction: @escaping () -> Void
    ) -> UIViewController {
        let viewModel = AmbiguousAddressSelectionViewModel(
            analyticsService: analyticsService,
            localAuthorityService: localAuthorityService,
            ambiguousAuthorities: localAuthorities,
            navigateToSuccessView: navigateToConfirmationView,
            dismissAction: dismissAction
        )
        let view = AmbiguousAddressSelectionView(
            viewModel: viewModel
        )
        return HostingViewController(rootView: view)
    }

    @MainActor
    func notificationSettings(analyticsService: AnalyticsServiceInterface,
                              completeAction: @escaping () -> Void,
                              dismissAction: @escaping () -> Void) -> UIViewController {
        let viewModel = NotificationsOnboardingViewModel(
            urlOpener: UIApplication.shared,
            analyticsService: analyticsService,
            showImage: false,
            completeAction: completeAction,
            dismissAction: dismissAction
        )
        let view = NotificationsOnboardingView(
            viewModel: viewModel
        )
        let viewController = HostingViewController(rootView: view)
        viewController.navigationItem.largeTitleDisplayMode = .never
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }

    @MainActor
    func notificationOnboarding(analyticsService: AnalyticsServiceInterface,
                                completeAction: @escaping () -> Void,
                                dismissAction: @escaping () -> Void) -> UIViewController {
        let viewModel = NotificationsOnboardingViewModel(
            urlOpener: UIApplication.shared,
            analyticsService: analyticsService,
            showImage: true,
            completeAction: completeAction,
            dismissAction: dismissAction
        )
        let view = NotificationsOnboardingView(
            viewModel: viewModel
        )
        let viewController = HostingViewController(
            rootView: view,
            navigationBarHidden: true
        )
        return viewController
    }

    @MainActor
    func signOutConfirmation(authenticationService: AuthenticationServiceInterface,
                             analyticsService: AnalyticsServiceInterface,
                             completion: @escaping (Bool) -> Void) -> UIViewController {
        let viewModel = SignOutConfirmationViewModel(
            authenticationService: authenticationService,
            analyticsService: analyticsService,
            completion: completion
        )
        let view = SignOutConfirmationView(viewModel: viewModel)
        let viewController = HostingViewController(rootView: view)
        return viewController
    }

    @MainActor
    func signedOut(authenticationService: AuthenticationServiceInterface,
                   analyticsService: AnalyticsServiceInterface,
                   completion: @escaping () -> Void) -> UIViewController {
        let viewModel = SignedOutViewModel(
            authenticationService: authenticationService,
            analyticsService: analyticsService,
            completion: completion
        )
        let view = InfoView(viewModel: viewModel)
        let viewController = HostingViewController(rootView: view)
        return viewController
    }

    @MainActor
    func signInError(analyticsService: AnalyticsServiceInterface,
                     completion: @escaping () -> Void) -> UIViewController {
        let viewModel = SignInErrorViewModel(
            analyticsService: analyticsService,
            completion: completion
        )
        let view = InfoView(viewModel: viewModel)
        let viewController = HostingViewController(rootView: view)
        return viewController
    }

    @MainActor
    func localAuthorityConfirmationScreen(
        analyticsService: AnalyticsServiceInterface,
        localAuthorityItem: Authority,
        completion: @escaping () -> Void) -> UIViewController {
            let viewModel = LocalAuthorityConfirmationViewModel(
                analyticsService: analyticsService,
                localAuthorityItem: localAuthorityItem,
                completion: completion
            )
            let view = LocalAuthorityConfirmationView(
                viewModel: viewModel
            )
            let viewController = HostingViewController(
                rootView: view
            )
            return viewController
        }

    @MainActor
    // swiftlint:disable:next function_parameter_count
    func topicDetail(topic: DisplayableTopic,
                     topicsService: TopicsServiceInterface,
                     analyticsService: AnalyticsServiceInterface,
                     activityService: ActivityServiceInterface,
                     subtopicAction: @escaping (DisplayableTopic) -> Void,
                     stepByStepAction: @escaping ([TopicDetailResponse.Content]) -> Void,
                     openAction: @escaping (URL) -> Void
    ) -> UIViewController {
        let actions = TopicDetailViewModel.Actions(
            subtopicAction: subtopicAction,
            stepByStepAction: stepByStepAction,
            openAction: openAction
        )
        let viewModel = TopicDetailViewModel(
            topic: topic,
            topicsService: topicsService,
            analyticsService: analyticsService,
            activityService: activityService,
            urlOpener: UIApplication.shared,
            actions: actions
        )

        let view = TopicDetailView(viewModel: viewModel)
        let viewController = HostingViewController(
            rootView: view
        )
        viewController.navigationItem.largeTitleDisplayMode = .never
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
    func webViewController(for url: URL) -> UIViewController {
        return WebViewController(url: url)
    }

    @MainActor
    func safari(url: URL) -> UIViewController {
        let config = SFSafariViewController.Configuration()
        config.barCollapsingEnabled = true
        let viewController = SFSafariViewController(
            url: url,
            configuration: config
        )
        viewController.modalPresentationStyle = .formSheet
        viewController.isModalInPresentation = true
        return viewController
    }
}
