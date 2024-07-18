import UIKit
import Foundation
import Factory

@MainActor
class CoordinatorBuilder {
    private let container: Container

    init(container: Container) {
        self.container = container
    }

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

    func onboarding(navigationController: UINavigationController,
                    dismissAction: @escaping () -> Void) -> BaseCoordinator {
        OnboardingCoordinator(
            navigationController: navigationController,
            onboardingService: container.onboardingService.resolve(),
            dismissAction: dismissAction
        )
    }

    var red: TabItemCoordinator {
        RedCoordinator(
            navigationController: .red,
            coodinatorBuilder: self,
            viewControllerBuilder: ViewControllerBuilder(),
            deeplinkStore: .red(coordinatorBuilder: self)
        )
    }

    var blue: TabItemCoordinator {
        BlueCoordinator(
            navigationController: .blue,
            coordinatorBuilder: self,
            viewControllerBuilder: ViewControllerBuilder(),
            deeplinkStore: .driving(coordinatorBuilder: self)
        )
    }

    var green: TabItemCoordinator {
        ColorCoordinator(
            navigationController: .green,
            color: .green,
            title: "Green",
            coordinatorBuilder: self
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
