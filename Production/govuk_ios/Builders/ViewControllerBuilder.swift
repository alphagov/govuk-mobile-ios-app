// swiftlint:disable file_length
import Foundation
import UIKit
import SwiftUI
import Factory
import GOVKit
import SafariServices

@MainActor
// swiftlint:disable:next type_body_length
class ViewControllerBuilder {
    func launch(analyticsService: AnalyticsServiceInterface,
                completion: @escaping () -> Void) -> UIViewController {
        let viewModel = LaunchViewModel(
            animationsCompletedAction: completion
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
        let userDefaultService: UserDefaultsServiceInterface
        let chatService: ChatServiceInterface
    }

    struct HomeActions {
        let feedbackAction: () -> Void
        let notificationsAction: () -> Void
        let recentActivityAction: () -> Void
        let localAuthorityAction: () -> Void
        let editLocalAuthorityAction: () -> Void
        let openURLAction: (URL) -> Void
        let openSearchAction: (SearchItem) -> Void
    }

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
            openURLAction: actions.openURLAction,
            openAction: actions.openSearchAction,
            urlOpener: UIApplication.shared,
            searchService: dependencies.searchService,
            activityService: dependencies.activityService,
            localAuthorityService: dependencies.localAuthorityService,
            userDefaultService: dependencies.userDefaultService,
            chatService: dependencies.chatService
        )
        return HomeViewController(
            viewModel: viewModel
        )
    }

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

    func localAuthorityPostcodeEntryView(
        analyticsService: AnalyticsServiceInterface,
        localAuthorityService: LocalAuthorityServiceInterface,
        resolveAmbiguityAction: @escaping (AmbiguousAuthorities, String) -> Void,
        localAuthoritySelected: @escaping (Authority) -> Void,
        dismissAction: @escaping () -> Void
    ) -> UIViewController {
        let viewModel = LocalAuthorityPostcodeEntryViewModel(
            service: localAuthorityService,
            analyticsService: analyticsService,
            resolveAmbiguityAction: resolveAmbiguityAction,
            localAuthoritySelected: localAuthoritySelected,
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
        localAuthoritySelected: @escaping (Authority) -> Void,
        selectAddressAction: @escaping () -> Void,
        dismissAction: @escaping () -> Void
    ) -> UIViewController {
        let viewModel = AmbiguousAuthoritySelectionViewModel(
            analyticsService: analyticsService,
            localAuthorityService: localAuthorityService,
            ambiguousAuthorities: localAuthorities,
            postCode: postCode,
            localAuthoritySelected: localAuthoritySelected,
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
        localAuthoritySelected: @escaping (Authority) -> Void,
        dismissAction: @escaping () -> Void
    ) -> UIViewController {
        let viewModel = AmbiguousAddressSelectionViewModel(
            analyticsService: analyticsService,
            localAuthorityService: localAuthorityService,
            ambiguousAuthorities: localAuthorities,
            localAuthoritySelected: localAuthoritySelected,
            dismissAction: dismissAction
        )
        let view = AmbiguousAddressSelectionView(
            viewModel: viewModel
        )
        return HostingViewController(rootView: view)
    }

    func faceIdSettings(
        analyticsService: AnalyticsServiceInterface,
        authenticationService: AuthenticationServiceInterface,
        localAuthenticationService: LocalAuthenticationServiceInterface,
        urlOpener: URLOpener
    ) -> UIViewController {
        let viewModel = LocalAuthenticationSettingsViewModel(
            authenticationService: authenticationService,
            localAuthenticationService: localAuthenticationService,
            analyticsService: analyticsService,
            urlOpener: urlOpener
        )
        let localAuthenticationSettingsView = FaceIdSettingsView(
            viewModel: viewModel
        )

        let viewController = HostingViewController(
            rootView: localAuthenticationSettingsView,
            statusBarStyle: .darkContent
        )
        viewController.title = viewModel.title

        viewController.navigationItem.largeTitleDisplayMode = .always
        return viewController
    }

    func touchIdSettings(
        analyticsService: AnalyticsServiceInterface,
        authenticationService: AuthenticationServiceInterface,
        localAuthenticationService: LocalAuthenticationServiceInterface,
        urlOpener: URLOpener
    ) -> UIViewController {
        let viewModel = LocalAuthenticationSettingsViewModel(
            authenticationService: authenticationService,
            localAuthenticationService: localAuthenticationService,
            analyticsService: analyticsService,
            urlOpener: urlOpener
        )
        let touchIdSettingsView = TouchIdSettingsView(
            viewModel: viewModel
        )

        let viewController = HostingViewController(
            rootView: touchIdSettingsView,
            statusBarStyle: .darkContent
        )
        viewController.title = viewModel.title

        viewController.navigationItem.largeTitleDisplayMode = .always
        return viewController
    }

    func notificationSettings(analyticsService: AnalyticsServiceInterface,
                              completeAction: @escaping () -> Void,
                              dismissAction: @escaping () -> Void,
                              viewPrivacyAction: @escaping () -> Void) -> UIViewController {
        let viewModel = NotificationsOnboardingViewModel(
            analyticsService: analyticsService,
            showImage: false,
            completeAction: completeAction,
            dismissAction: dismissAction,
            viewPrivacyAction: viewPrivacyAction
        )
        let view = NotificationsOnboardingView(
            viewModel: viewModel
        )
        let viewController = HostingViewController(rootView: view)
        viewController.navigationItem.largeTitleDisplayMode = .never
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }

    func notificationOnboarding(analyticsService: AnalyticsServiceInterface,
                                completeAction: @escaping () -> Void,
                                dismissAction: @escaping () -> Void,
                                viewPrivacyAction: @escaping () -> Void) -> UIViewController {
        let viewModel = NotificationsOnboardingViewModel(
            analyticsService: analyticsService,
            showImage: true,
            completeAction: completeAction,
            dismissAction: dismissAction,
            viewPrivacyAction: viewPrivacyAction
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

    func analyticsConsent(analyticsService: any AnalyticsServiceInterface,
                          completion: @escaping () -> Void,
                          viewPrivacyAction: @escaping () -> Void) -> UIViewController {
        let viewModel = AnalyticsConsentContainerViewModel(
            analyticsService: analyticsService,
            completion: completion,
            viewPrivacyAction: viewPrivacyAction
        )
        let view = AnalyticsConsentContainerView(
            viewModel: viewModel
        )
        let viewController = HostingViewController(
            rootView: view,
            navigationBarHidden: true
        )
        return viewController
    }

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

    func signInError(completion: @escaping () -> Void) -> UIViewController {
        let viewModel = SignInErrorViewModel(
            completion: completion
        )
        let view = InfoView<SignInErrorViewModel>(viewModel: viewModel)
        let viewController = HostingViewController(rootView: view)
        return viewController
    }

    func localAuthorityConfirmationScreen(
        analyticsService: AnalyticsServiceInterface,
        localAuthorityItem: Authority,
        dismiss: @escaping () -> Void
    ) -> UIViewController {
            let viewModel = LocalAuthorityConfirmationViewModel(
                analyticsService: analyticsService,
                localAuthorityItem: localAuthorityItem,
                dismiss: dismiss
            )
            let view = LocalAuthorityConfirmationView(viewModel: viewModel)
            let viewController = HostingViewController(rootView: view)
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

    func stepByStep(content: [TopicDetailResponse.Content],
                    analyticsService: AnalyticsServiceInterface,
                    activityService: ActivityServiceInterface,
                    selectedAction: @escaping (TopicDetailResponse.Content) -> Void
    ) -> UIViewController {
        let viewModel = StepByStepsViewModel(
            content: content,
            analyticsService: analyticsService,
            activityService: activityService,
            selectedAction: selectedAction
        )
        let view = TopicDetailView(viewModel: viewModel)
        let viewController = HostingViewController(
            rootView: view
        )
        viewController.navigationItem.largeTitleDisplayMode =
        UINavigationItem.LargeTitleDisplayMode.never
        return viewController
    }

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

    func chat(analyticsService: AnalyticsServiceInterface,
              chatService: ChatServiceInterface,
              openURLAction: @escaping (URL) -> Void,
              handleError: @escaping (ChatError) -> Void) -> UIViewController {
        let viewModel = ChatViewModel(
            chatService: chatService,
            analyticsService: analyticsService,
            openURLAction: openURLAction,
            handleError: handleError
        )

        let viewController = HostingViewController(
            rootView: ChatView(
                viewModel: viewModel
            ),
            navigationBarHidden: true
        )
        return viewController
    }

    func chatError(analyticsService: AnalyticsServiceInterface,
                   error: ChatError,
                   action: @escaping () -> Void) -> UIViewController {
        let viewModel = ChatErrorViewModel(
            analyticsService: analyticsService,
            error: error,
            action: action
        )
        let view = InfoView<ChatErrorViewModel>(viewModel: viewModel)
        let viewController = HostingViewController(
            rootView: view,
            navigationBarHidden: true
        )
        return viewController
    }

    func web(for url: URL) -> UIViewController {
        return WebViewController(url: url)
    }

    func safari(url: URL) -> UIViewController {
        let config = SFSafariViewController.Configuration()
        config.barCollapsingEnabled = true
        let viewController = SFSafariViewController(
            url: url,
            configuration: config
        )
        return viewController
    }

    func welcomeOnboarding(viewModel: WelcomeOnboardingViewModel) -> UIViewController {
        let containerView = InfoView(
            viewModel: viewModel
        )
        return HostingViewController(
            rootView: containerView
        )
    }

    func notificationConsentAlert(
        analyticsService: AnalyticsServiceInterface,
        viewPrivacyAction: @escaping () -> Void,
        grantConsentAction: @escaping () -> Void,
        openSettingsAction: @escaping (UIViewController) -> Void
    ) -> UIViewController {
        let viewController = NotificationConsentAlertViewController(
            analyticsService: analyticsService
        )
        viewController.viewPrivacyAction = viewPrivacyAction
        viewController.grantConsentAction = grantConsentAction
        viewController.openSettingsAction = {
            openSettingsAction(viewController)
        }
        return viewController
    }

    func chatInfoOnboarding(
        analyticsService: AnalyticsServiceInterface,
        completionAction: @escaping () -> Void,
        cancelOnboardingAction: @escaping () -> Void
    ) -> UIViewController {
        let viewModel = ChatInfoOnboardingViewModel(
            analyticsService: analyticsService,
            completionAction: completionAction,
            cancelOnboardingAction: cancelOnboardingAction
        )
        let containerView = InfoView<ChatInfoOnboardingViewModel>(
            viewModel: viewModel
        )
        let viewController = HostingViewController(
            rootView: containerView
        )
        viewController.navigationItem.rightBarButtonItem = viewModel.rightBarButtonItem
        viewController.isModalInPresentation = true
        return viewController
    }

    func chatConsentOnboarding(
        analyticsService: AnalyticsServiceInterface,
        chatService: ChatServiceInterface,
        cancelOnboardingAction: @escaping () -> Void,
        completionAction: @escaping () -> Void
    ) -> UIViewController {
        let viewModel = ChatConsentOnboardingViewModel(
            analyticsService: analyticsService,
            chatService: chatService,
            cancelOnboardingAction: cancelOnboardingAction,
            completionAction: completionAction
        )
        let containerView = InfoView<ChatConsentOnboardingViewModel>(
            viewModel: viewModel,
            customView: {
                AnyView(InfoIconListView(
                    list: [
                        InfoIconListItem(
                            text: String.chat.localized("onboardingConsentFirstListItemText"),
                            iconName: "info.circle"
                        ),
                        InfoIconListItem(
                            text: String.chat.localized("onboardingConsentSecondListItemText"),
                            iconName: "filemenu.and.cursorarrow"
                        )
                    ]
                ))
            }
        )
        let viewController = HostingViewController(
            rootView: containerView,
            navigationBarTintColor: .govUK.text.link
        )
        viewController.navigationItem.rightBarButtonItem = viewModel.rightBarButtonItem
        viewController.isModalInPresentation = true
        return viewController
    }

    func chatOptIn(
        analyticsService: AnalyticsServiceInterface,
        chatService: ChatServiceInterface,
        openURLAction: @escaping (URL) -> Void,
        completionAction: @escaping () -> Void
    ) -> UIViewController {
        let viewModel = ChatOptInViewModel(
            analyticsService: analyticsService,
            chatService: chatService,
            completionAction: completionAction
        )
        let linksView = InfoLinksView(
            linkList: [
                InfoLinkListItem(
                    text: String.chat.localized("optInPrivacyLinkTitle"),
                    url: chatService.privacyPolicy
                ),
                InfoLinkListItem(
                    text: String.chat.localized("optInTermsLinkTitle"),
                    url: chatService.termsAndConditions
                )
            ],
            openURLAction: openURLAction
        )
        let containerView = InfoView<ChatOptInViewModel>(
            viewModel: viewModel,
            customView: { AnyView(linksView) }
        )
        return HostingViewController(
            rootView: containerView
        )
    }

    func chatOffboarding(
        analyticsService: AnalyticsServiceInterface,
        chatService: ChatServiceInterface,
        openURLAction: @escaping (URL) -> Void,
        completionAction: @escaping () -> Void
    ) -> UIViewController {
        let viewModel = ChatOffboardingViewModel(
            analyticsService: analyticsService,
            chatService: chatService,
            completionAction: completionAction
        )
        let linksView = InfoLinksView(
            linkList: [
                InfoLinkListItem(
                    text: String.chat.localized("feedbackMenuAccessibilityTitle"),
                    url: chatService.feedback
                )
            ],
            openURLAction: openURLAction
        )
        let containerView = InfoView<ChatOffboardingViewModel>(
            viewModel: viewModel,
            customView: { AnyView(linksView) }
        )
        return HostingViewController(
            rootView: containerView
        )
    }
}
// swiftlint:enable file_length
