import UIKit
import Foundation
import Factory

@MainActor
class CoordinatorBuilder {
    private let container: Container

    init(container: Container) {
        self.container = container
    }

    func app(navigationController: UINavigationController, userDefaults: UserDefaults) -> BaseCoordinator {
        AppCoordinator(
            coordinatorBuilder: self,
            navigationController: navigationController,
            deeplinkService: container.deeplinkService(),
            userDefaults: userDefaults
        )
    }

    func launch(navigationController: UINavigationController,
                completion: @escaping () -> Void) -> BaseCoordinator {
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

    func onboarding(navigationController: UINavigationController,
                    dismissAction: @escaping () -> Void) -> BaseCoordinator {
        OnboardingCoordinator(
            navigationController: navigationController,
            dismissAction: dismissAction
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
