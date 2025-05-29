import UIKit
import Foundation

class AppCoordinator: BaseCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder
    private let inactivityService: InactivityServiceInterface
    private var initialLaunch: Bool = true
    private lazy var tabCoordinator: BaseCoordinator = {
        coordinatorBuilder.tab(
            navigationController: root
        )
    }()

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
            firstLaunch(url: url)
        } else {
            reLaunch(url: url)
        }
    }

    private func startInactivityMonitoring() {
        let coordinator = coordinatorBuilder.inactivityCoordinator(
            navigationController: root,
            inactivityService: inactivityService,
            inactiveAction: { [weak self] in
                self?.root.dismiss(animated: true)
                self?.startReauthentication(url: nil)
            }
        )
        start(coordinator)
    }

    private func firstLaunch(url: URL?) {
        let coordinator = InitialLaunchCoordinator(
            coordinatorBuilder: coordinatorBuilder,
            navigationController: root,
            completion: { [weak self] in
                self?.initialLaunch = false
                self?.startTabs(url: url)
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

    private func startReauthentication(url: URL?) {
        let coordinator = coordinatorBuilder.reauthentication(
            navigationController: root,
            completionAction: { [weak self] in
                self?.startTabs(url: nil)
            },
            newUserAction: { [weak self] in
                self?.startNewUserOnboardingCoordinator(url: nil)
            }
        )
        start(coordinator, url: url)
    }

    private func startSignedOutCoordinator(url: URL?) {
        let coordinator = coordinatorBuilder.signedOut(
            navigationController: root,
            completion: { [weak self] _ in
                self?.firstLaunch(url: nil)
//                if signedIn {
//                    self?.startTabs(
//                        url: URL(string: "govuk://settings/settings")
//                    )
//                } else {
//                    self?.startAuthenticationOnboardingCoordinator(
//                        url: nil,
//                        newUserAction: { [weak self] in
//                            self?.startNewUserOnboardingCoordinator(url: nil)
//                        }
//                    )
//                }
            }
        )
        start(coordinator, url: url)
    }

    private func startNewUserOnboardingCoordinator(url: URL?) {
        let coordinator = coordinatorBuilder.newUserOnboarding(
            navigationController: root,
            completionAction: { [weak self] in
                self?.startTabs(url: nil)
            }
        )
        start(coordinator)
    }

    private func startTabs(url: URL?) {
        start(tabCoordinator, url: url)
    }

    override func childDidFinish(_ child: BaseCoordinator) {
        super.childDidFinish(child)
        if child is TabCoordinator {
            startSignedOutCoordinator(url: nil)
//            tabCoordinator = coordinatorBuilder.tab(
//                navigationController: root
//            )
        }
    }
}
