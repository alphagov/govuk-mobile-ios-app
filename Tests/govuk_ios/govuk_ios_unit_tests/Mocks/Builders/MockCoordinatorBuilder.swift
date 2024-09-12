import UIKit
import Foundation
import Factory

@testable import govuk_ios

extension CoordinatorBuilder {
    static var mock: MockCoordinatorBuilder {
        MockCoordinatorBuilder(container: Container())
    }
}

class MockCoordinatorBuilder: CoordinatorBuilder {

    var _stubbedTabCoordinator: MockBaseCoordinator?
    var _receivedTabNavigationController: UINavigationController?
    override func tab(navigationController: UINavigationController) -> BaseCoordinator {
        _receivedTabNavigationController = navigationController
        return _stubbedTabCoordinator ??
        MockBaseCoordinator(
            navigationController: navigationController
        )
    }

    var _stubbedLaunchCoordinator: MockBaseCoordinator?
    var _receivedLaunchNavigationController: UINavigationController?
    var _receivedLaunchCompletion: (() -> Void)?
    override func launch(navigationController: UINavigationController,
                         completion: @escaping () -> Void) -> BaseCoordinator {
        _receivedLaunchNavigationController = navigationController
        _receivedLaunchCompletion = completion
        return _stubbedLaunchCoordinator ??
        MockBaseCoordinator(
            navigationController: navigationController
        )
    }
    
    var _stubbedPermitCoordinator: MockBaseCoordinator?
    var _receivedPermitPermitId: String?
    var _receivedPermitNavigationController: UINavigationController?
    override func permit(permitId: String,
                         navigationController: UINavigationController) -> BaseCoordinator {
        _receivedPermitPermitId = permitId
        _receivedPermitNavigationController = navigationController
        return _stubbedPermitCoordinator ??
        MockBaseCoordinator(
            navigationController: navigationController
        )
    }

    var _stubbedDrivingCoordinator: MockBaseCoordinator?
    var _receivedDrivingNavigationController: UINavigationController?
    override func driving(navigationController: UINavigationController) -> BaseCoordinator {
        _receivedDrivingNavigationController = navigationController
        return _stubbedDrivingCoordinator ?? MockBaseCoordinator()
    }

    var _stubbedNextCoordinator: MockBaseCoordinator?
    var _receivedNextTitle: String?
    var _receivedNextNavigationController: UINavigationController?
    override func next(title: String,
                       navigationController: UINavigationController) -> BaseCoordinator {
        _receivedNextTitle = title
        _receivedNextNavigationController = navigationController
        return _stubbedNextCoordinator ?? MockBaseCoordinator()
    }
    
    var _stubbedHomeCoordinator: TabItemCoordinator?
    override var home: any TabItemCoordinator {
        _stubbedHomeCoordinator ??
        MockBaseCoordinator(
            navigationController: .init()
        )
    }
    
    var _stubbedSettingsCoordinator: TabItemCoordinator?
    override var settings: any TabItemCoordinator {
        _stubbedSettingsCoordinator ??
        MockBaseCoordinator(
            navigationController: .init()
        )
    }

    var _stubbedAnalyticsConsentCoordinator: BaseCoordinator?
    var _receivedAnalyticsConsentNavigationController: UINavigationController?
    var _receivedAnalyticsConsentDismissAction: (() -> Void)?

    override func analyticsConsent(navigationController: UINavigationController,
                                   dismissAction: @escaping () -> Void) -> BaseCoordinator {
        _receivedAnalyticsConsentNavigationController = navigationController
        _receivedAnalyticsConsentDismissAction = dismissAction
        return _stubbedAnalyticsConsentCoordinator ??
        MockBaseCoordinator(
            navigationController: .init()
        )
    }

    var _stubbedOnboardingCoordinator: BaseCoordinator?
    var _receivedOnboardingNavigationController: UINavigationController?
    var _receivedOnboardingDismissAction: (() -> Void)?
    override func onboarding(navigationController: UINavigationController,
                             dismissAction: @escaping () -> Void) -> BaseCoordinator {
        _receivedOnboardingNavigationController = navigationController
        _receivedOnboardingDismissAction = dismissAction
        return _stubbedOnboardingCoordinator ??
        MockBaseCoordinator(
            navigationController: .init()
        )
    }

    var _stubbedSearchCoordinator: MockBaseCoordinator?
    var _receivedSearchNavigationController: UINavigationController?
    override func search(navigationController: UINavigationController) -> BaseCoordinator {
        _receivedSearchNavigationController = navigationController
        return _stubbedSearchCoordinator ?? MockBaseCoordinator()
    }
}
