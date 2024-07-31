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

    var home: TabItemCoordinator {
        HomeCoordinator(
            navigationController: .home,
            coordinatorBuilder: self,
            viewControllerBuilder: ViewControllerBuilder(),
            deeplinkStore: .home(coordinatorBuilder: self),
            analyticsService: container.analyticsService.resolve()
        )
    }

    var settings: TabItemCoordinator {
        SettingsCoordinator(
            navigationController: .settings,
            coordinatorBuilder: self,
            viewControllerBuilder: ViewControllerBuilder(),
            deeplinkStore: .settings(coordinatorBuilder: self),
            analyticsService: container.analyticsService.resolve()
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
