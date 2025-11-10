import UIKit
import Foundation

class AppCoordinator: BaseCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder
    private let inactivityService: InactivityServiceInterface
    private let authenticationService: AuthenticationServiceInterface
    private let localAuthenticationService: LocalAuthenticationServiceInterface
    private var initialLaunch: Bool = true
    private lazy var tabCoordinator: BaseCoordinator = {
        let coordinator = coordinatorBuilder.tab(
            navigationController: root
        )
        return coordinator
    }()
    private var pendingDeeplink: URL?
    private var privacyPresenter: PrivacyPresenting?

    init(coordinatorBuilder: CoordinatorBuilder,
         inactivityService: InactivityServiceInterface,
         authenticationService: AuthenticationServiceInterface,
         localAuthenticationService: LocalAuthenticationServiceInterface,
         privacyPresenter: PrivacyPresenting? = nil,
         navigationController: UINavigationController) {
        self.coordinatorBuilder = coordinatorBuilder
        self.inactivityService = inactivityService
        self.authenticationService = authenticationService
        self.localAuthenticationService = localAuthenticationService
        self.privacyPresenter = privacyPresenter
        super.init(navigationController: navigationController)
        configureObservers()
    }

    private func configureObservers() {
        authenticationService.didSignOutAction = { [weak self] reason in
            if reason == .reauthFailure {
                // Any presented modals need to be dismissed or they
                // will be on top of the sign in flow
                self?.root.dismiss(animated: false)
                self?.hidePrivacyScreen()
                return
            }
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
                guard self?.authenticationService.isSignedIn == true else { return }
                self?.authenticationService.clearRefreshToken()
                self?.showPrivacyScreen()
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
        if let url = pendingDeeplink {
            tabCoordinator.start(url: url)
            pendingDeeplink = nil
        }
    }

    private func startTabs() {
        start(tabCoordinator, url: pendingDeeplink)
        pendingDeeplink = nil
    }
}

extension AppCoordinator {
    private func showPrivacyScreen() {
        if shouldShowPrivacyScreen {
            privacyPresenter?.showPrivacyScreen()
        }
    }

    private func hidePrivacyScreen() {
        privacyPresenter?.hidePrivacyScreen()
    }

    private var shouldShowPrivacyScreen: Bool {
        (localAuthenticationService.availableAuthType == .faceID ||
        localAuthenticationService.touchIdEnabled)
    }
}
