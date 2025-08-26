import Foundation
import UIKit
import GOVKit

class ChatOptInCoordinator: BaseCoordinator {
    private let viewControllerBuilder: ViewControllerBuilder
    private let analyticsService: AnalyticsServiceInterface
    private let chatService: ChatServiceInterface
    private let completionAction: () -> Void
    private lazy var chatOptInViewController: UIViewController = {
        viewControllerBuilder.chatOptIn(
            analyticsService: analyticsService,
            chatService: chatService,
            completionAction: completionAction
        )
    }()

    init(navigationController: UINavigationController,
         viewControllerBuilder: ViewControllerBuilder,
         analyticsService: AnalyticsServiceInterface,
         chatService: ChatServiceInterface,
         completionAction: @escaping () -> Void) {
        self.viewControllerBuilder = viewControllerBuilder
        self.analyticsService = analyticsService
        self.chatService = chatService
        self.completionAction = completionAction
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        set(chatOptInViewController)
    }
}
