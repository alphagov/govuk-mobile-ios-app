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
    override func home(searchButtonPrimaryAction: @escaping () -> Void,
                       configService: AppConfigServiceInterface,
                       topicsService: TopicsServiceInterface,
                       recentActivityAction: @escaping () -> Void,
                       topicAction: @escaping ((Topic) -> Void)) -> UIViewController {
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
    override func topicDetail(topic: Topic, analyticsService: any AnalyticsServiceInterface) -> UIViewController {
        return _stubbedTopicDetailViewController ?? UIViewController()
    }
}
