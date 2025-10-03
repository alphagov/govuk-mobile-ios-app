import UIKit
import Foundation

class AppCoordinator: BaseCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder
    private let inactivityService: InactivityServiceInterface
    private let authenticationService: AuthenticationServiceInterface
    private var initialLaunch: Bool = true
    private var tabCoordinator: BaseCoordinator?
    private var pendingDeeplink: URL?

    init(coordinatorBuilder: CoordinatorBuilder,
         inactivityService: InactivityServiceInterface,
         authenticationService: AuthenticationServiceInterface,
         navigationController: UINavigationController) {
        self.coordinatorBuilder = coordinatorBuilder
        self.inactivityService = inactivityService
        self.authenticationService = authenticationService
        super.init(navigationController: navigationController)
        configureObservers()
    }

    private func configureObservers() {
        authenticationService.didSignOutAction = { [weak self] reason in
            guard reason != .reauthFailure else { return }
            self?.startPeriAuthCoordinator()
        }
    }

    override func start(url: URL?) {
        startInactivityMonitoring()
        pendingDeeplink = url ?? pendingDeeplink
        if initialLaunch {
            startPreAuthCoordinator()
        } else {
            reLaunch()
        }
    }

    private func startInactivityMonitoring() {
        inactivityService.startMonitoring(
            inactivityHandler: { [weak self] in
                self?.showPrivacyScreen()
                self?.authenticationService.clearRefreshToken()
                self?.startPeriAuthCoordinator()
            }
        )
    }

    private func startPreAuthCoordinator() {
        let coordinator = coordinatorBuilder.preAuth(
            navigationController: root,
            completion: { [weak self] in
                self?.initialLaunch = false
                self?.startPeriAuthCoordinator()
            }
        )
        start(coordinator)
    }

    private func startPeriAuthCoordinator() {
        let coordinator = coordinatorBuilder.periAuth(
            navigationController: root,
            completion: { [weak self] in
                self?.hidePrivacyScreen()
                self?.startPostAuthCoordinator()
            }
        )
        start(coordinator)
    }

    private func startPostAuthCoordinator() {
        let coordinator = coordinatorBuilder.postAuth(
            navigationController: root,
            completion: { [weak self] in
                self?.startTabs()
            }
        )
        start(coordinator)
    }

    private func reLaunch() {
        let coordinator = coordinatorBuilder.relaunch(
            navigationController: root,
            completion: { [weak self] in
                self?.handlePendingDeeplink()
            }
        )
        start(coordinator)
    }

    private func handlePendingDeeplink() {
        if let tabCoordinator = self.tabCoordinator,
           let url = pendingDeeplink {
            tabCoordinator.start(url: url)
            pendingDeeplink = nil
        }
    }

    private func startTabs() {
        let coordinator = coordinatorBuilder.tab(
            navigationController: root
        )
        tabCoordinator = coordinator
        start(coordinator, url: pendingDeeplink)
        pendingDeeplink = nil
    }
}

extension AppCoordinator: PrivacyPresenting {
    func showPrivacyScreen() {
        if privacyCoordinator == nil,
           authenticationService.isSignedIn {
            root.dismiss(animated: false)
            let coordinator = coordinatorBuilder.privacy()
            present(coordinator, animated: false)
        }
    }

    func hidePrivacyScreen() {
        privacyCoordinator?.dismiss(animated: false)
        privacyCoordinator?.finish()
    }

    private var privacyCoordinator: BaseCoordinator? {
        childCoordinators.first(where: { $0 is PrivacyProviding })
    }
}
