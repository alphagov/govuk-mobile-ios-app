import Foundation
import UIKit
import GOVKit

class ChatConsentOnboardingCoordinator: BaseCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder
    private let viewControllerBuilder: ViewControllerBuilder
    private let analyticsService: AnalyticsServiceInterface
    private let chatService: ChatServiceInterface
    private let cancelOnboardingAction: () -> Void
    private let completionAction: () -> Void
    private lazy var chatConsentOnboardingViewController: UIViewController = {
        viewControllerBuilder.chatConsentOnboarding(
            analyticsService: analyticsService,
            chatService: chatService,
            cancelOnboardingAction: { [weak self] in
                self?.dismiss(animated: true)
                self?.cancelOnboardingAction()
                self?.finish()
            },
            completionAction: { [weak self] in
                self?.dismiss(animated: true)
                self?.completionAction()
                self?.finish()
            }
        )
    }()

    init(navigationController: UINavigationController,
         coordinatorBuilder: CoordinatorBuilder,
         viewControllerBuilder: ViewControllerBuilder,
         analyticsService: AnalyticsServiceInterface,
         chatService: ChatServiceInterface,
         cancelOnboardingAction: @escaping () -> Void,
         completionAction: @escaping () -> Void) {
        self.coordinatorBuilder = coordinatorBuilder
        self.viewControllerBuilder = viewControllerBuilder
        self.analyticsService = analyticsService
        self.chatService = chatService
        self.cancelOnboardingAction = cancelOnboardingAction
        self.completionAction = completionAction
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        push(chatConsentOnboardingViewController)
    }
}
