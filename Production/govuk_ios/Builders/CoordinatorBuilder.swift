import UIKit
import Foundation

@MainActor
class CoordinatorBuilder {
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
            title: "Red"
        )
    }

    var blue: BaseCoordinator {
        ColorCoordinator(
            navigationController: .blue,
            color: .blue,
            title: "Blue"
        )
    }

    var green: BaseCoordinator {
        ColorCoordinator(
            navigationController: .green,
            color: .green,
            title: "Green"
        )
    }
}
