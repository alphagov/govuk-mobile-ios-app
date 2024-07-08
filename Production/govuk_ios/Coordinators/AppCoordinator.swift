import UIKit
import Foundation

class AppCoordinator: BaseCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder
    private let deeplinkService: DeeplinkServiceInterface
    private let userDefaults: UserDefaults

    init(coordinatorBuilder: CoordinatorBuilder,
         navigationController: UINavigationController,
         deeplinkService: DeeplinkServiceInterface,
         userDefaults: UserDefaults) {
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
                self?.shouldShowOnboarding(key: .hasOnboarded)
            }
        )
        start(coordinator)
    }

    private func showOnboarding() {
        let coordinator = coordinatorBuilder.onboarding(
            navigationController: root,
            dismissAction: {  [weak self] in
                guard let self = self else { return }
            self.userDefaults.set(true, forKey: UserDefaultKeys.hasOnboarded.rawValue)
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

    private func shouldShowOnboarding(key: UserDefaultKeys) {
        if userDefaults.bool(forKey: key.rawValue) {
            showTabs()
        } else {
            showOnboarding()
        }
    }
}

    private enum UserDefaultKeys: String {
        case hasOnboarded
    }
