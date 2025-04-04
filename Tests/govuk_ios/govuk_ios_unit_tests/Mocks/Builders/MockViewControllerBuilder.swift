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
    var _receivedHomeSearchAction: (() -> Void)?
    var _receivedHomeRecentActivityAction: (() -> Void)?
    var _receivedTopicWidgetViewModel: TopicsWidgetViewModel?
    override func home(dependencies: HomeDependencies, actions: HomeActions) -> UIViewController {
        _receivedHomeRecentActivityAction = actions.recentActivityAction
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

    var _stubbedTopicDetailViewController: UIViewController?
    override func topicDetail(topic: any DisplayableTopic,
                              topicsService: any TopicsServiceInterface,
                              analyticsService: any AnalyticsServiceInterface,
                              activityService: any ActivityServiceInterface,
                              subtopicAction: @escaping (any DisplayableTopic) -> Void,
                              stepByStepAction: @escaping ([TopicDetailResponse.Content]) -> Void) -> UIViewController {
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
                                       notificationService: any NotificationServiceInterface,
                                       completeAction: @escaping () -> Void) -> UIViewController {
        _stubbedNotificationSettingsViewController ?? UIViewController()
    }
}
