import UIKit
import Foundation

import Factory

@MainActor
class CoordinatorBuilder {
    func app(navigationController: UINavigationController) -> BaseCoordinator {
        AppCoordinator(
            coordinatorBuilder: self,
            navigationController: navigationController
        )
    }

    func launch(navigationController: UINavigationController,
                completion: @escaping () -> Void) -> BaseCoordinator {
        LaunchCoordinator(
            navigationController: navigationController,
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
        ColorCoordinator(
            navigationController: .red,
            color: .red,
            title: "Red",
            coordinatorBuilder: self
        )
    }

    var blue: BaseCoordinator {
        BlueCoordinator(
            navigationController: .blue,
            coordinatorBuilder: self
        )
    }

    var green: BaseCoordinator {
        ColorCoordinator(
            navigationController: .green,
            color: .green,
            title: "Green",
            coordinatorBuilder: self
        )
    }

    func driving(navigationController: UINavigationController) -> BaseCoordinator {
        DrivingCoordinator(
            navigationController: navigationController
        )
    }

    func next(title: String,
              navigationController: UINavigationController) -> BaseCoordinator {
        NextCoordinator(
            title: title,
            navigationController: navigationController
        )
    }
}
