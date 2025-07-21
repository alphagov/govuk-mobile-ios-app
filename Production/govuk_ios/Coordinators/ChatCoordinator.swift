import Foundation
import UIKit
import GOVKit

class ChatCoordinator: TabItemCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder
    private let deeplinkStore: DeeplinkDataStore
    private let analyticsService: AnalyticsServiceInterface
    private let chatService: ChatServiceInterface

    var isEnabled: Bool {
        chatService.isEnabled
    }

    init(navigationController: UINavigationController,
         coordinatorBuilder: CoordinatorBuilder,
         deepLinkStore: DeeplinkDataStore,
         analyticsService: AnalyticsServiceInterface,
         chatService: ChatServiceInterface) {
        self.coordinatorBuilder = coordinatorBuilder
        self.deeplinkStore = deepLinkStore
        self.analyticsService = analyticsService
        self.chatService = chatService
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        let viewModel = ChatViewModel(
            chatService: chatService,
            analyticsService: analyticsService,
            openURLAction: { [weak self] url in
                self?.presentWebView(url: url,
                                    fullScreen: false)
            }
        )

        let viewController = HostingViewController(
            rootView: ChatView(
                viewModel: viewModel
            ),
            navigationBarHidden: true
        )

        set(viewController)
    }

    func route(for url: URL) -> ResolvedDeeplinkRoute? {
        deeplinkStore.route(
            for: url,
            parent: self
        )
    }

    private func presentWebView(url: URL, fullScreen: Bool) {
        let coordinator = coordinatorBuilder.safari(
            navigationController: root,
            url: url,
            fullScreen: fullScreen
        )
        start(coordinator)
    }

    func didReselectTab() { /* To be implemented */ }
}
