import Foundation
import UIKit
import GOVKit

class ChatCoordinator: TabItemCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder
    private let viewControllerBuilder: ViewControllerBuilder
    private let deeplinkStore: DeeplinkDataStore
    private let analyticsService: AnalyticsServiceInterface
    private let chatService: ChatServiceInterface
    private lazy var chatViewController: UIViewController = {
        viewControllerBuilder.chat(
            analyticsService: analyticsService,
            chatService: chatService,
            openURLAction: presentWebView,
            handleError: handleError)
    }()

    var isEnabled: Bool {
        chatService.isEnabled
    }

    init(navigationController: UINavigationController,
         coordinatorBuilder: CoordinatorBuilder,
         viewControllerBuilder: ViewControllerBuilder,
         deepLinkStore: DeeplinkDataStore,
         analyticsService: AnalyticsServiceInterface,
         chatService: ChatServiceInterface) {
        self.coordinatorBuilder = coordinatorBuilder
        self.viewControllerBuilder = viewControllerBuilder
        self.deeplinkStore = deepLinkStore
        self.analyticsService = analyticsService
        self.chatService = chatService
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        set(chatViewController)
    }

    func route(for url: URL) -> ResolvedDeeplinkRoute? {
        deeplinkStore.route(
            for: url,
            parent: self
        )
    }

    private func presentWebView(url: URL) {
        let coordinator = coordinatorBuilder.safari(
            navigationController: root,
            url: url,
            fullScreen: true
        )
        start(coordinator)
    }

    func didReselectTab() { /* To be implemented */ }

    private func handleError(_ error: Error) {
        let viewController = viewControllerBuilder.chatError(
            error: error,
            action: { [weak self] in
                guard let self else { return }
                if error as? ChatError == ChatError.networkUnavailable {
                    self.set(
                        self.chatViewController,
                        animated: false
                    )
                } else {
                    self.openGovUK()
                }
            })

        set(viewController, animated: false)
    }

    private func openGovUK() {
        let coordinator = coordinatorBuilder.safari(
            navigationController: root,
            url: Constants.API.govukBaseUrl,
            fullScreen: false
        )
        start(coordinator)
    }
}
