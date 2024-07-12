import UIKit
import Foundation

@testable import govuk_ios

extension CoordinatorBuilder {
    static var mock: MockCoordinatorBuilder {
        MockCoordinatorBuilder()
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

    var _stubbedRedCoordinator: TabItemCoordinator?
    override var red: any TabItemCoordinator {
        _stubbedRedCoordinator ??
        MockBaseCoordinator(
            navigationController: .init()
        )
    }

    var _stubbedBlueCoordinator: TabItemCoordinator?
    override var blue: any TabItemCoordinator {
        return _stubbedBlueCoordinator ??
        MockBaseCoordinator(
            navigationController: .init()
        )
    }

    var _stubbedGreenCoordinator: TabItemCoordinator?
    override var green: any TabItemCoordinator {
        _stubbedGreenCoordinator ??
        MockBaseCoordinator(
            navigationController: .init()
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

}
