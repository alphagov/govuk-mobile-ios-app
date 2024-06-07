import UIKit
import Foundation

@MainActor
class CoordinatorBuilder {
    func launch(navigationController: UINavigationController,
                completion: @escaping (String?) -> Void) -> BaseCoordinator {
        LaunchCoordinator(
            navigationController: navigationController,
             completion: completion, paths: []
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
            deepLinkPaths: []
        )
    }

    var blue: BaseCoordinator {
        ColorCoordinator(
            navigationController: .blue,
            color: .blue,
            title: "Blue",
            deepLinkPaths: []
        )
    }

    var green: BaseCoordinator {
        ColorCoordinator(
            navigationController: .green,
            color: .green,
            title: "Green",
            deepLinkPaths: []
        )
    }
}
