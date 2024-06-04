import UIKit
import Foundation

@MainActor
class CoordinatorBuilder {
    func launch(navigationController: UINavigationController, url: String?,
                completion: @escaping () -> Void) -> BaseCoordinator {
        LaunchCoordinator(
            navigationController: navigationController,
            url: url, completion: completion, paths: []
        )
    }

    func tab(navigationController: UINavigationController, url: String?) -> BaseCoordinator {
        TabCoordinator(
            coordinatorBuilder: self,
            navigationController: navigationController, url: url
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
