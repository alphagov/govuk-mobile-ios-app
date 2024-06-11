import UIKit
import Foundation

import Factory

class CoordinatorBuilder {
    private let container: Container

    init(container: Container) {
        self.container = container
    }

    func app(navigationController: UINavigationController) -> BaseCoordinator {
        AppCoordinator(
            coordinatorBuilder: self,
            navigationController: navigationController,
            deeplinkService: container.deeplinkService()
        )
    }

    func launch(navigationController: UINavigationController,
                completion: @escaping (String?) -> Void) -> BaseCoordinator {
        LaunchCoordinator(
            navigationController: navigationController,
            deeplinkService: container.deeplinkService(),
            completion: completion
        )
    }

    func tab(navigationController: UINavigationController) -> BaseCoordinator {
        TabCoordinator(
            coordinatorBuilder: self,
            navigationController: navigationController
        )
    }

    var red: BaseCoordinator {
        RedCoordinator(
            navigationController: .red
        )
    }

    func blue(requestFocus: @escaping (UINavigationController) -> Void) -> BaseCoordinator {
        BlueCoordinator(
            navigationController: .blue,
            requestFocus: requestFocus
        )
    }

    var green: BaseCoordinator {
        ColorCoordinator(
            navigationController: .green,
            color: .green,
            title: "Green"
        )
    }

    var driving: BaseCoordinator {
        DrivingCoordinator(
            navigationController: .green
        )
    }
}
