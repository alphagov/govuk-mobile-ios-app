import UIKit
import Foundation

@MainActor
class CoordinatorBuilder {
    func launch(navigationController: UINavigationController,
                completion: @escaping (String?) -> Void) -> BaseCoordinator {
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
