import UIKit
import Foundation

class AppCoordinator: BaseCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder
    private let inactivityService: InactivityServiceInterface
    private var initialLaunch: Bool = true
    private var tabCoordinator: BaseCoordinator?
    private var pendingDeeplink: URL?

    init(coordinatorBuilder: CoordinatorBuilder,
         inactivityService: InactivityServiceInterface,
         navigationController: UINavigationController) {
        self.coordinatorBuilder = coordinatorBuilder
        self.inactivityService = inactivityService
        super.init(navigationController: navigationController)
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
                self?.root.dismiss(animated: true)
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

    override func childDidFinish(_ child: BaseCoordinator) {
        super.childDidFinish(child)
        if child is TabCoordinator {
            startPeriAuthCoordinator()
        }
    }
}
