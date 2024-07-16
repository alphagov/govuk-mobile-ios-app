import UIKit
import Foundation

class AppCoordinator: BaseCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder
    private let deeplinkService: DeeplinkServiceInterface
    private let userDefaults: OnboardingPersistanceInterface

    init(coordinatorBuilder: CoordinatorBuilder,
         navigationController: UINavigationController,
         deeplinkService: DeeplinkServiceInterface,
         userDefaults: OnboardingPersistanceInterface) {
        self.coordinatorBuilder = coordinatorBuilder
        self.deeplinkService = deeplinkService
        self.userDefaults = userDefaults
        super.init(navigationController: navigationController)
    }

    override func start() {
        startLaunch()
    }

    private func startLaunch() {
        let coordinator = coordinatorBuilder.launch(
            navigationController: root,
            completion: { [weak self] in
                guard let self = self else { return }
                if self.userDefaults.hasOnboarded(forKey: .hasOnboarded) == false {
                    showOnboarding()
                } else {
                    showTabs()
                }
            }
        )
        start(coordinator)
    }

    private func showOnboarding() {
        let coordinator = coordinatorBuilder.onboarding(
            navigationController: root,
            dismissAction: {  [weak self] in
                guard let self = self else { return }
                self.userDefaults.setFlag(forkey: .hasOnboarded, to: true)
                self.showTabs()
            })
        start(coordinator)
    }

    private func showTabs() {
        let coordinator = coordinatorBuilder.tab(
            navigationController: root
        )
        start(coordinator)
    }
}
