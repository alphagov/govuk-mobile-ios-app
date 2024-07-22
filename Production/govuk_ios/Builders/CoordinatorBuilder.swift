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

    var home: TabItemCoordinator {
        HomeCoordinator(
            navigationController: .home,
            coodinatorBuilder: self,
            viewControllerBuilder: ViewControllerBuilder(),
            deeplinkStore: .home(coordinatorBuilder: self)
        )
    }

    var settings: TabItemCoordinator {
        SettingsCoordinator(
            navigationController: .settings,
            coodinatorBuilder: self,
            viewControllerBuilder: ViewControllerBuilder(),
            deeplinkStore: .settings(coordinatorBuilder: self)
        )
    }

    func launch(navigationController: UINavigationController,
                completion: @escaping () -> Void) -> BaseCoordinator {
        LaunchCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: ViewControllerBuilder(),
            completion: completion
        )
    }

    func tab(navigationController: UINavigationController) -> BaseCoordinator {
        TabCoordinator(
            coordinatorBuilder: self,
            navigationController: navigationController
        )
    }

    func driving(navigationController: UINavigationController) -> BaseCoordinator {
        DrivingCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: self,
            viewControllerBuilder: ViewControllerBuilder()
        )
    }

    func permit(permitId: String,
                navigationController: UINavigationController) -> BaseCoordinator {
        PermitCoordinator(
            permitId: permitId,
            navigationController: navigationController,
            viewControllerBuilder: ViewControllerBuilder()
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
