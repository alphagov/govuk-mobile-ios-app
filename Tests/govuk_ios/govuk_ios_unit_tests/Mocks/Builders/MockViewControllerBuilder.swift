import Foundation
import UIKit
import GOVKit

@testable import govuk_ios

extension ViewControllerBuilder {
    static var mock: MockViewControllerBuilder {
        MockViewControllerBuilder()
    }
}

class MockViewControllerBuilder: ViewControllerBuilder {
    var _stubbedLaunchViewController: UIViewController?
    var _receivedLaunchCompletion: (() -> Void)?
    override func launch(analyticsService: AnalyticsServiceInterface,
                         completion: @escaping () -> Void) -> UIViewController {
        _receivedLaunchCompletion = completion
        return _stubbedLaunchViewController ?? UIViewController()
    }

    var _stubbedHomeViewController: UIViewController?
    var _receivedHomeSearchAction: ((SearchItem) -> Void)?
    var _receivedEditLocalAuthorityAction: (() -> Void)?
    var _receivedHomeRecentActivityAction: (() -> Void)?
    var _receivedTopicWidgetViewModel: TopicsWidgetViewModel?
    override func home(dependencies: HomeDependencies,
                       actions: HomeActions) -> UIViewController {
        _receivedEditLocalAuthorityAction = actions.editLocalAuthorityAction
        _receivedHomeRecentActivityAction = actions.recentActivityAction
        _receivedHomeSearchAction = actions.openSearchAction
        _receivedTopicWidgetViewModel = dependencies.topicWidgetViewModel
        return _stubbedHomeViewController ?? UIViewController()
    }

    var _receivedAnalyticsConsentViewPrivacyAction: (() -> Void)?
    var _stubbedAnalyticsConsentViewController: UIViewController?
    override func analyticsConsent(analyticsService: any AnalyticsServiceInterface,
                                   completion: @escaping () -> Void,
                                   viewPrivacyAction: @escaping () -> Void) -> UIViewController {
        _receivedAnalyticsConsentViewPrivacyAction = viewPrivacyAction
        return _stubbedAnalyticsConsentViewController ?? UIViewController()
    }

    var _stubbedSettingsViewController: UIViewController?
    var _receivedSettingsViewModel: (any SettingsViewModelInterface)?
    override func settings<T: SettingsViewModelInterface>(viewModel: T) -> UIViewController {
        _receivedSettingsViewModel = viewModel
        return _stubbedSettingsViewController ?? UIViewController()
    }

    var _stubbedRecentActivityViewController: UIViewController?
    var _receivedRecentActivitySelectedAction: ((URL) -> Void)?
    override func recentActivity(analyticsService: any AnalyticsServiceInterface,
                                 activityService: any ActivityServiceInterface,
                                 selectedAction: @escaping (URL) -> Void) -> UIViewController {
        _receivedRecentActivitySelectedAction = selectedAction
        return _stubbedRecentActivityViewController ?? UIViewController()
    }

    var _receivedTopicDetailOpenAction: ((URL) -> Void)?
    var _receivedTopicDetailStepByStepAction: (([TopicDetailResponse.Content]) -> Void)?
    var _stubbedTopicDetailViewController: UIViewController?
    override func topicDetail(topic: any DisplayableTopic,
                              topicsService: any TopicsServiceInterface,
                              analyticsService: any AnalyticsServiceInterface,
                              activityService: any ActivityServiceInterface,
                              subtopicAction: @escaping (any DisplayableTopic) -> Void,
                              stepByStepAction: @escaping ([TopicDetailResponse.Content]) -> Void,
                              openAction: @escaping (URL) -> Void) -> UIViewController {
        _receivedTopicDetailOpenAction = openAction
        _receivedTopicDetailStepByStepAction = stepByStepAction
        return _stubbedTopicDetailViewController ?? UIViewController()
    }

    var _stubbedEditTopicsViewController: UIViewController?
    var _receivedDismissAction: (() -> Void)?
    override func editTopics(analyticsService: any AnalyticsServiceInterface,
                             topicsService: any TopicsServiceInterface,
                             dismissAction: @escaping () -> Void) -> UIViewController {
        _receivedDismissAction = dismissAction
        return _stubbedEditTopicsViewController ?? UIViewController()
    }
    var _stubbedLocalAuthorityPostcodeEntryViewController: UIViewController?
    var _receivedLocalAuthorityDismissAction: (() -> Void)?
    var _receivedResolveAmbiguityAction: ((AmbiguousAuthorities, String) -> Void)?
    override func localAuthorityPostcodeEntryView(analyticsService: AnalyticsServiceInterface,
                                                  localAuthorityService: LocalAuthorityServiceInterface,
                                                  resolveAmbiguityAction: @escaping (AmbiguousAuthorities, String) -> Void,
                                                  localAuthoritySelected: @escaping (Authority) -> Void,
                                                  dismissAction: @escaping () -> Void) -> UIViewController {
        _receivedLocalAuthorityDismissAction = dismissAction
        _receivedResolveAmbiguityAction = resolveAmbiguityAction
        return _stubbedLocalAuthorityPostcodeEntryViewController ?? UIViewController()
    }

    var _stubbedLocalAuthorityExplainerViewController: UIViewController?
    var _receivedNavigateToPostCodeEntryViewAction: (() -> Void)?
    var _receivedLocalAuthorityExplainerDismissAction: (() -> Void)?
    override func localAuthorityExplainerView(analyticsService: AnalyticsServiceInterface,
                                              navigateToPostCodeEntryViewAction: @escaping () -> Void,
                                              dismissAction: @escaping () -> Void) -> UIViewController {
        _receivedNavigateToPostCodeEntryViewAction = navigateToPostCodeEntryViewAction
        _receivedLocalAuthorityExplainerDismissAction = dismissAction
        return _stubbedLocalAuthorityExplainerViewController ?? UIViewController()
    }

    var _stubbedAmbiguousAuthoritySelectionViewController: UIViewController?
    var _receivedAmbiguousAuthoritySelectAddressAction: (() -> Void)?
    var _receivedAmbiguousAuthorityDismissAction: (() -> Void)?
    override func ambiguousAuthoritySelectionView(analyticsService: AnalyticsServiceInterface,
                                                  localAuthorityService: LocalAuthorityServiceInterface,
                                                  localAuthorities: AmbiguousAuthorities,
                                                  postCode: String,
                                                  localAuthoritySelected: @escaping (Authority) -> Void,
                                                  selectAddressAction: @escaping () -> Void,
                                                  dismissAction: @escaping () -> Void
    ) -> UIViewController {
        _receivedAmbiguousAuthoritySelectAddressAction = selectAddressAction
        _receivedAmbiguousAuthorityDismissAction = dismissAction
        return _stubbedAmbiguousAuthoritySelectionViewController ?? UIViewController()
    }

    var _stubbedAmbiguousAddressSelectionViewController: UIViewController?
    var _receivedAmbiguousAddressDismissAction: (() -> Void)?
    override func ambiguousAddressSelectionView(analyticsService: AnalyticsServiceInterface,
                                                localAuthorityService: LocalAuthorityServiceInterface,
                                                localAuthorities: AmbiguousAuthorities,
                                                localAuthoritySelected: @escaping (Authority) -> Void,
                                                dismissAction: @escaping () -> Void
    ) -> UIViewController {
        _receivedAmbiguousAddressDismissAction = dismissAction
        return _stubbedAmbiguousAddressSelectionViewController ?? UIViewController()
    }

    var _stubbedAllTopicsViewController: UIViewController?
    var _receivedTopicAction: ((Topic) -> Void)?
    override func allTopics(analyticsService: AnalyticsServiceInterface,
                            topicAction: @escaping (Topic) -> Void,
                            topicsService topicService: TopicsServiceInterface) -> UIViewController {
        _receivedTopicAction = topicAction
        return _stubbedAllTopicsViewController ?? UIViewController()
    }

    var _receivedTopicOnboardingDismissAction: (() -> Void)?
    var _receivedTopicOnboardingTopics: [Topic]?
    var _stubbedTopicOnboardingViewController: UIViewController?
    override func topicOnboarding(topics: [Topic],
                                  analyticsService: any AnalyticsServiceInterface,
                                  topicsService: any TopicsServiceInterface,
                                  dismissAction: @escaping () -> Void) -> UIViewController {
        _receivedTopicOnboardingTopics = topics
        _receivedTopicOnboardingDismissAction = dismissAction
        return _stubbedTopicOnboardingViewController ?? UIViewController()
    }

    var _receivedNotificationSettingsViewPrivacyAction: (() -> Void)?
    var _stubbedNotificationSettingsViewController: UIViewController?
    override func notificationSettings(analyticsService: any AnalyticsServiceInterface,
                                       completeAction: @escaping () -> Void,
                                       dismissAction: @escaping () -> Void,
                                       viewPrivacyAction: @escaping () -> Void
    ) -> UIViewController {
        _receivedNotificationSettingsViewPrivacyAction = viewPrivacyAction
        return _stubbedNotificationSettingsViewController ?? UIViewController()
    }

    var _stubbedSignOutConfirmationViewController: UIViewController?
    var _receivedSignOutConfirmationCompletion: ((Bool) -> Void)?
    override func signOutConfirmation(authenticationService: any AuthenticationServiceInterface,
                                      analyticsService: any AnalyticsServiceInterface,
                                      completion: @escaping (Bool) -> Void) -> UIViewController {
        _receivedSignOutConfirmationCompletion = completion
        return _stubbedSignOutConfirmationViewController ?? UIViewController()
    }

    var _receivedSignInErrorCompletion: (() -> Void)?
    var _stubbedSignInErrorViewController: UIViewController?
    override func signInError(completion: @escaping () -> Void) -> UIViewController {
        _receivedSignInErrorCompletion = completion
        return _stubbedSignInErrorViewController ?? UIViewController()

    }

    var _receivedStepByStepContent: [TopicDetailResponse.Content]?
    var _receivedStepByStepSelectedAction: ((TopicDetailResponse.Content) -> Void)?
    var _stubbedStepByStepViewController: UIViewController?
    override func stepByStep(content: [TopicDetailResponse.Content],
                             analyticsService: any AnalyticsServiceInterface,
                             activityService: any ActivityServiceInterface,
                             selectedAction: @escaping (TopicDetailResponse.Content) -> Void
    ) -> UIViewController {
        _receivedStepByStepContent = content
        _receivedStepByStepSelectedAction = selectedAction
        return _stubbedStepByStepViewController ?? UIViewController()
    }

    var _receivedSafariUrl: URL?
    var _stubbedSafariViewController: UIViewController?
    override func safari(url: URL) -> UIViewController {
        _receivedSafariUrl = url
        return _stubbedSafariViewController ?? UIViewController()
    }

    var _stubbedWelcomeOnboardingViewController: UIViewController?
    var _receivedWelcomeOnboardingCompletion: (() -> Void)?
    override func welcomeOnboarding(completion: @escaping () -> Void) -> UIViewController {
        _receivedWelcomeOnboardingCompletion = completion
        return _stubbedWelcomeOnboardingViewController ?? UIViewController()
    }

    var _receivedNotificationConsentAlertGrantConsentAction: (() -> Void)?
    var _receivedNotificationConsentAlertViewPrivacyAction: (() -> Void)?
    var _receivedNotificationConsentAlertOpenSettingsAction: ((UIViewController) -> Void)?
    var _stubbedNotificationConsentAlertViewController: UIViewController?
    override func notificationConsentAlert(
        analyticsService: any AnalyticsServiceInterface,
        viewPrivacyAction: @escaping () -> Void,
        grantConsentAction: @escaping () -> Void,
        openSettingsAction: @escaping (UIViewController) -> Void
    ) -> UIViewController {
        _receivedNotificationConsentAlertViewPrivacyAction = viewPrivacyAction
        _receivedNotificationConsentAlertGrantConsentAction = grantConsentAction
        _receivedNotificationConsentAlertOpenSettingsAction = openSettingsAction
        return _stubbedNotificationConsentAlertViewController ?? UIViewController()
    }

    var _receivedNotificationOnboardingViewPrivacyAction: (() -> Void)?
    var _stubbedNotificationOnboardingViewController: UIViewController?
    override func notificationOnboarding(analyticsService: any AnalyticsServiceInterface,
                                         completeAction: @escaping () -> Void,
                                         dismissAction: @escaping () -> Void,
                                         viewPrivacyAction: @escaping () -> Void
    ) -> UIViewController {
        _receivedNotificationOnboardingViewPrivacyAction = viewPrivacyAction
        return _stubbedNotificationOnboardingViewController ?? UIViewController()
    }

    var _stubbedFaceIdSettingsController: UIViewController?
    override func faceIdSettings(
        analyticsService: AnalyticsServiceInterface,
        authenticationService: AuthenticationServiceInterface,
        localAuthenticationService: LocalAuthenticationServiceInterface,
        urlOpener: URLOpener
    ) -> UIViewController {
        return _stubbedFaceIdSettingsController ?? UIViewController()
    }

    var _stubbedTouchIdSettingsController: UIViewController?
    override func touchIdSettings(
        analyticsService: AnalyticsServiceInterface,
        authenticationService: AuthenticationServiceInterface,
        localAuthenticationService: LocalAuthenticationServiceInterface,
        urlOpener: URLOpener
    ) -> UIViewController {
        return _stubbedTouchIdSettingsController ?? UIViewController()
    }

    var _stubbedChatController: UIViewController?
    var _receivedChatOpenURLAction: ((URL) -> Void)?
    var _receivedHandleChatError: ((ChatError) -> Void)?
    override func chat(
        analyticsService: AnalyticsServiceInterface,
        chatService: ChatServiceInterface,
        openURLAction: @escaping (URL) -> Void,
        handleError: @escaping (ChatError) -> Void
    ) -> UIViewController {
        _receivedChatOpenURLAction = openURLAction
        _receivedHandleChatError = handleError
        return _stubbedChatController ?? UIViewController()
    }

    var _stubbedChatErrorController: UIViewController?
    var _receivedChatErrorAction: (() -> Void)?
    override func chatError(
        error: ChatError,
        action: @escaping () -> Void
    ) -> UIViewController {
        _receivedChatErrorAction = action
        return _stubbedChatErrorController ?? UIViewController()
    }

    var _stubbedChatInfoOnboardingController: UIViewController?
    override func chatInfoOnboarding(
        analyticsService: AnalyticsServiceInterface,
        completionAction: @escaping () -> Void,
        cancelOnboardingAction: @escaping () -> Void
    ) -> UIViewController {
        return _stubbedChatInfoOnboardingController ?? UIViewController()
    }

    var _stubbedChatConsentOnboardingController: UIViewController?
    override func chatConsentOnboarding(
        analyticsService: AnalyticsServiceInterface,
        chatService: ChatServiceInterface,
        cancelOnboardingAction: @escaping () -> Void,
        completionAction: @escaping () -> Void
    ) -> UIViewController {
        return _stubbedChatConsentOnboardingController ?? UIViewController()
    }

    var _stubbedChatOptInController: UIViewController?
    override func chatOptIn(
        analyticsService: AnalyticsServiceInterface,
        chatService: ChatServiceInterface,
        openURLAction: @escaping (URL) -> Void,
        completionAction: @escaping () -> Void
    ) -> UIViewController {
        return _stubbedChatOptInController ?? UIViewController()
    }
}
