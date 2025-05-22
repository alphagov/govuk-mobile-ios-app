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

    var _stubbedSettingsViewController: UIViewController?
    var _receivedSettingsViewModel: (any SettingsViewModelInterface)?
    override func settings<T: SettingsViewModelInterface>(viewModel: T) -> UIViewController {
        _receivedSettingsViewModel = viewModel
        return _stubbedSettingsViewController ?? UIViewController()
    }

    var _stubbedRecentActivityViewController: UIViewController?
    override func recentActivity(analyticsService: AnalyticsServiceInterface,
                                 activityService: ActivityServiceInterface) -> UIViewController {
        return _stubbedRecentActivityViewController ?? UIViewController()
    }

    var _receivedTopicDetailOpenAction: ((URL) -> Void)?
    var _stubbedTopicDetailViewController: UIViewController?
    override func topicDetail(topic: any DisplayableTopic,
                              topicsService: any TopicsServiceInterface,
                              analyticsService: any AnalyticsServiceInterface,
                              activityService: any ActivityServiceInterface,
                              subtopicAction: @escaping (any DisplayableTopic) -> Void,
                              stepByStepAction: @escaping ([TopicDetailResponse.Content]) -> Void,
                              openAction: @escaping (URL) -> Void) -> UIViewController {
        _receivedTopicDetailOpenAction = openAction
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

    var _stubbedNotificationSettingsViewController: UIViewController?
    override func notificationSettings(analyticsService: any AnalyticsServiceInterface,
                                       completeAction: @escaping () -> Void,
                                       dismissAction: @escaping () -> Void) -> UIViewController {
        _stubbedNotificationSettingsViewController ?? UIViewController()
    }

    var _stubbedSignOutConfirmationViewController: UIViewController?
    var _receivedSignOutConfirmationCompletion: ((Bool) -> Void)?
    override func signOutConfirmation(authenticationService: any AuthenticationServiceInterface,
                                      analyticsService: any AnalyticsServiceInterface,
                                      completion: @escaping (Bool) -> Void) -> UIViewController {
        _receivedSignOutConfirmationCompletion = completion
        return _stubbedSignOutConfirmationViewController ?? UIViewController()
    }

    var _receivedSignedOutCompletion: (() -> Void)?
    var _stubbedSignedOutViewController: UIViewController?
    override func signedOut(authenticationService: AuthenticationServiceInterface,
                            analyticsService: AnalyticsServiceInterface,
                            completion: @escaping () -> Void) -> UIViewController {
        _receivedSignedOutCompletion = completion
        return _stubbedSignedOutViewController ?? UIViewController()
    }

    var _receivedSignInErrorCompletion: (() -> Void)?
    var _stubbedSignInErrorViewController: UIViewController?
    override func signInError(analyticsService: any AnalyticsServiceInterface,
                              completion: @escaping () -> Void) -> UIViewController {
        _receivedSignInErrorCompletion = completion
        return _stubbedSignInErrorViewController ?? UIViewController()

    }

    var _receivedSafariUrl: URL?
    var _stubbedSafariViewController: UIViewController?
    override func safari(url: URL) -> UIViewController {
        _receivedSafariUrl = url
        return _stubbedSafariViewController ?? UIViewController()
    }
}
