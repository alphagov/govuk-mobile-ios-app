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
            analyticsService: analyticsService
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

    func didReselectTab() { /* To be implemented */ }
}
