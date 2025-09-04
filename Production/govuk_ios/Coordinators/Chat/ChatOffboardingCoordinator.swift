import Foundation
import UIKit
import GOVKit

class ChatOffboardingCoordinator: BaseCoordinator {
    private let viewControllerBuilder: ViewControllerBuilder
    private let coordinatorBuilder: CoordinatorBuilder
    private let analyticsService: AnalyticsServiceInterface
    private let chatService: ChatServiceInterface
    private let completionAction: () -> Void
    private lazy var chatOffboardingViewController: UIViewController = {
        viewControllerBuilder.chatOffboarding(
            analyticsService: analyticsService,
            chatService: chatService,
            openURLAction: presentWebView,
            completionAction: completionAction
        )
    }()

    init(navigationController: UINavigationController,
         viewControllerBuilder: ViewControllerBuilder,
         coordinatorBuilder: CoordinatorBuilder,
         analyticsService: AnalyticsServiceInterface,
         chatService: ChatServiceInterface,
         completionAction: @escaping () -> Void) {
        self.viewControllerBuilder = viewControllerBuilder
        self.coordinatorBuilder = coordinatorBuilder
        self.analyticsService = analyticsService
        self.chatService = chatService
        self.completionAction = completionAction
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        guard shouldOffboardChat else {
            completionAction()
            return
        }
        set(chatOffboardingViewController)
    }

    private func presentWebView(url: URL) {
        let coordinator = coordinatorBuilder.safari(
            navigationController: root,
            url: url,
            fullScreen: true
        )
        start(coordinator)
    }

    private var shouldOffboardChat: Bool {
        !chatService.chatTestActive && chatService.chatOptedIn == true
    }
}
