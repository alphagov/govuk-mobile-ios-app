import Foundation
import UIKit

@testable import govuk_ios

extension ViewControllerBuilder {
    static var mock: MockViewControllerBuilder {
        MockViewControllerBuilder()
    }
}

class MockViewControllerBuilder: ViewControllerBuilder {
    var _stubbedDrivingViewController: UIViewController?
    var _receivedDrivingShowPermitAction: (() -> Void)?
    var _receivedDrivingPresentPermitAction: (() -> Void)?
    override func driving(showPermitAction: @escaping () -> Void,
                          presentPermitAction: @escaping () -> Void) -> UIViewController {
        _receivedDrivingShowPermitAction = showPermitAction
        _receivedDrivingPresentPermitAction = presentPermitAction
        return _stubbedDrivingViewController ?? UIViewController()
    }

    var _stubbedLaunchViewController: UIViewController?
    var _receivedLaunchCompletion: (() -> Void)?
    override func launch(completion: @escaping () -> Void) -> UIViewController {
        _receivedLaunchCompletion = completion
        return _stubbedLaunchViewController ?? UIViewController()
    }

    var _stubbedPermitViewController: UIViewController?
    var _receivedPermitFinishAction: (() -> Void)?
    override func permit(permitId: String,
                         finishAction: @escaping () -> Void) -> UIViewController {
        _receivedPermitFinishAction = finishAction
        return _stubbedPermitViewController ?? UIViewController()
    }

    var _stubbedHomeViewController: UIViewController?
    var _receivedHomeSearchAction: (() -> Void)?
    var _receivedHomeRecentActivityAction: (() -> Void)?
    var _receivedTopicWidgetViewModel: TopicsWidgetViewModel?
    override func home(analyticsService: any AnalyticsServiceInterface,
                       configService: any AppConfigServiceInterface,
                       topicWidgetViewModel: TopicsWidgetViewModel,
                       searchAction: @escaping () -> Void,
                       recentActivityAction: @escaping () -> Void) -> UIViewController {
        _receivedHomeSearchAction = searchAction
        _receivedHomeRecentActivityAction = recentActivityAction
        _receivedTopicWidgetViewModel = topicWidgetViewModel
        return _stubbedHomeViewController ?? UIViewController()
    }

    var _stubbedSettingsViewController: UIViewController?
    override func settings(analyticsService: AnalyticsServiceInterface) -> UIViewController {
        return _stubbedSettingsViewController ?? UIViewController()
    }

    var _stubbedSearchViewController: UIViewController?
    var _receivedSearchDismissAction: (() -> Void)?
    override func search(analyticsService: any AnalyticsServiceInterface,
                         searchService: any SearchServiceInterface,
                         dismissAction: @escaping () -> Void) -> UIViewController {
        _receivedSearchDismissAction = dismissAction
        return _stubbedSearchViewController ?? UIViewController()
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
    var _receivedDoneButtonAction: (() -> Void)?
    override func editTopics(
        analyticsService: any AnalyticsServiceInterface,
        topicsService: any TopicsServiceInterface,
        dismissAction: @escaping () -> Void) -> UIViewController {
            _receivedDoneButtonAction = dismissAction
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
}
