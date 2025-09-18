import Foundation
import UIKit
import GOVKit

class ChatOptInCoordinator: BaseCoordinator {
    private let viewControllerBuilder: ViewControllerBuilder
    private let coordinatorBuilder: CoordinatorBuilder
    private let analyticsService: AnalyticsServiceInterface
    private let chatService: ChatServiceInterface
    private let completionAction: () -> Void
    private lazy var chatOptInViewController: UIViewController = {
        viewControllerBuilder.chatOptIn(
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
        guard optInAvailable else {
            completionAction()
            return
        }
        set(chatOptInViewController)
    }

    private func presentWebView(url: URL) {
        let coordinator = coordinatorBuilder.safari(
            navigationController: root,
            url: url,
            fullScreen: true
        )
        start(coordinator)
    }

    private var optInAvailable: Bool {
        chatService.isEnabled &&
        chatService.chatOptInAvailable &&
        chatService.chatOptedIn == nil
    }
}
