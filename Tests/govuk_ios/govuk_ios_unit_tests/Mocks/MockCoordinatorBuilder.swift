import UIKit
import Foundation

@testable import govuk_ios

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
    override func launch(navigationController: UINavigationController, 
                         completion: @escaping (String?) -> Void) -> BaseCoordinator {
        _receivedLaunchNavigationController = navigationController
        return _stubbedLaunchCoordinator ??
        MockBaseCoordinator(
            navigationController: navigationController
        )
    }

    var _stubbedRedCoordinator: MockBaseCoordinator?
    override var red: BaseCoordinator {
        _stubbedRedCoordinator ??
        MockBaseCoordinator(
            navigationController: .init()
        )
    }

    var _stubbedBlueCoordinator: MockBaseCoordinator?
    override func blue(requestFocus: @escaping (UINavigationController) -> Void) -> BaseCoordinator {
        _stubbedBlueCoordinator ??
        MockBaseCoordinator(
            navigationController: .init()
        )
    }

    var _stubbedGreenCoordinator: MockBaseCoordinator?
    override var green: BaseCoordinator {
        _stubbedGreenCoordinator ?? 
        MockBaseCoordinator(
            navigationController: .init()
        )
    }

}
