import UIKit
import Foundation

@testable import govuk_ios

extension CoordinatorBuilder {
    static var mock: MockCoordinatorBuilder {
        MockCoordinatorBuilder(
            container: .init()
        )
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

    var _stubbedRedCoordinator: MockBaseCoordinator?
    override var red: BaseCoordinator {
        _stubbedRedCoordinator ??
        MockBaseCoordinator(
            navigationController: .init()
        )
    }

    var _stubbedBlueCoordinator: MockBaseCoordinator?
    override var blue: BaseCoordinator {
        return _stubbedBlueCoordinator ??
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
