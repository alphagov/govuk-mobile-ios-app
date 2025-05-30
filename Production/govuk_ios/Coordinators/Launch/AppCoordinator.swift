import UIKit
import Foundation

class AppCoordinator: BaseCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder
    private let inactivityService: InactivityServiceInterface
    private var initialLaunch: Bool = true

    init(coordinatorBuilder: CoordinatorBuilder,
         inactivityService: InactivityServiceInterface,
         navigationController: UINavigationController) {
        self.coordinatorBuilder = coordinatorBuilder
        self.inactivityService = inactivityService
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        startInactivityMonitoring()
        if initialLaunch {
            startPreAuthCoordinator(url: url)
        } else {
            reLaunch(url: url)
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

    private func startPreAuthCoordinator(url: URL?) {
        let coordinator = coordinatorBuilder.preauth(
            navigationController: root,
            completion: { [weak self] in
                self?.initialLaunch = false
                self?.startPeriAuthCoordinator()
            }
        )
        start(coordinator)
    }

    private func startPeriAuthCoordinator() {
        let coordinator = coordinatorBuilder.periauth(
            navigationController: root,
            completion: { [weak self] in
                self?.startPostAuthCoordinator()
            }
        )
        start(coordinator)
    }

    private func startPostAuthCoordinator() {
        let coordinator = coordinatorBuilder.postauth(
            navigationController: root,
            completion: { [weak self] in
                self?.startTabs(url: nil)
            }
        )
        start(coordinator)
    }

    private func reLaunch(url: URL?) {
        let coordinator = coordinatorBuilder.relaunch(
            navigationController: root,
            completion: {
                //  Removed actions here for now
            }
        )
        start(coordinator, url: url)
    }

    private func startTabs(url: URL?) {
        let coordinator = coordinatorBuilder.tab(
            navigationController: root
        )
        start(coordinator, url: url)
    }

    override func childDidFinish(_ child: BaseCoordinator) {
        super.childDidFinish(child)
        if child is TabCoordinator {
            startPeriAuthCoordinator()
        }
    }
}
