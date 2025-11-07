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
    private var lastPresentedViewController: UIViewController?

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
            guard reason != .reauthFailure else {
                self?.privacyCoordinator?.dismiss(animated: false)
                self?.privacyCoordinator?.finish()
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

extension AppCoordinator: PrivacyPresenting {
    private var privacyCoordinator: BaseCoordinator? {
        childCoordinators.first(where: { $0 is PrivacyProviding })
    }

    func showPrivacyScreen() {
        guard privacyCoordinator == nil,
              shouldShowPrivacyScreen else { return }
        if let presentedViewController = root.presentedViewController {
            lastPresentedViewController = presentedViewController
            presentedViewController.dismiss(animated: false)
        }
        let coordinator = coordinatorBuilder.privacy(
            navigationController: UINavigationController()
        )
        present(coordinator, animated: false)
    }

    func hidePrivacyScreen() {
        privacyCoordinator?.dismiss(animated: false)
        privacyCoordinator?.finish()
        if let lastPresentedViewController {
            root.present(
                lastPresentedViewController,
                animated: false
            ) { [weak self] in
                self?.lastPresentedViewController = nil
            }
        }
    }

    private var shouldShowPrivacyScreen: Bool {
        (localAuthenticationService.availableAuthType == .faceID ||
        localAuthenticationService.touchIdEnabled)
    }
}
