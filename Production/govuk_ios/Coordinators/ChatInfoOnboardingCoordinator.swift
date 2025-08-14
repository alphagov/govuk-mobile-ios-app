import Foundation
import UIKit
import GOVKit

class ChatInfoOnboardingCoordinator: BaseCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder
    private let viewControllerBuilder: ViewControllerBuilder
    private let analyticsService: AnalyticsServiceInterface
    private let cancelOnboardingAction: () -> Void
    private let setChatViewControllerAction: () -> Void
    private lazy var chatInfoOnboardingViewController: UIViewController = {
        viewControllerBuilder.chatInfoOnboarding(
            analyticsService: analyticsService,
            completionAction: { [weak self] in
                self?.startChatConsentOnboarding()
            },
            cancelOnboardingAction: { [weak self] in
                self?.dismiss(animated: true)
                self?.cancelOnboardingAction()
                self?.finish()
            }
        )
    }()

    init(navigationController: UINavigationController,
         coordinatorBuilder: CoordinatorBuilder,
         viewControllerBuilder: ViewControllerBuilder,
         analyticsService: AnalyticsServiceInterface,
         cancelOnboardingAction: @escaping () -> Void,
         setChatViewControllerAction: @escaping () -> Void) {
        self.coordinatorBuilder = coordinatorBuilder
        self.viewControllerBuilder = viewControllerBuilder
        self.analyticsService = analyticsService
        self.cancelOnboardingAction = cancelOnboardingAction
        self.setChatViewControllerAction = setChatViewControllerAction
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        set(chatInfoOnboardingViewController)
    }

    private func startChatConsentOnboarding() {
        let coordinator = coordinatorBuilder.chatConsentOnboarding(
            navigationController: root,
            cancelOnboardingAction: { [weak self] in
                self?.cancelOnboardingAction()
                self?.finish()
            },
            completionAction: { [weak self] in
                self?.setChatViewControllerAction()
                self?.finish()
            }
        )
        start(coordinator)
    }
}
