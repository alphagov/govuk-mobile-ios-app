import UIKit
import Foundation

class AppCoordinator: BaseCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder
    private let inactivityService: InactivityServiceInterface
    private let authenticationService: AuthenticationServiceInterface
    private let localAuthenticationService: LocalAuthenticationServiceInterface
    private var initialLaunch: Bool = true
    private var tabCoordinator: BaseCoordinator?
    private var pendingDeeplink: URL?

    init(coordinatorBuilder: CoordinatorBuilder,
         inactivityService: InactivityServiceInterface,
         authenticationService: AuthenticationServiceInterface,
         localAuthenticationService: LocalAuthenticationServiceInterface,
         navigationController: UINavigationController) {
        self.coordinatorBuilder = coordinatorBuilder
        self.inactivityService = inactivityService
        self.authenticationService = authenticationService
        self.localAuthenticationService = localAuthenticationService
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
                self?.authenticationService.clearRefreshToken()
                self?.showPrivacyScreen(appDidTimeout: true)
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
    func showPrivacyScreen(appDidTimeout: Bool) {
        guard privacyCoordinator == nil,
        shouldShowPrivacyScreen(appDidTimeout) else { return }

        root.dismiss(animated: false)
        let coordinator = coordinatorBuilder.privacy()
        present(coordinator, animated: false)
    }

    func hidePrivacyScreen() {
        privacyCoordinator?.dismiss(animated: false)
        privacyCoordinator?.finish()
    }

    private func shouldShowPrivacyScreen(_ appDidTimeout: Bool) -> Bool {
        if appDidTimeout {
            localAuthenticationService.availableAuthType == .faceID ||
            localAuthenticationService.touchIdEnabled
        } else {
            authenticationService.isSignedIn
        }
    }

    private var privacyCoordinator: BaseCoordinator? {
        childCoordinators.first(where: { $0 is PrivacyProviding })
    }
}
