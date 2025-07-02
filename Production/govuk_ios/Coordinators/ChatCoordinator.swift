import Foundation
import UIKit
import GOVKit

class ChatCoordinator: TabItemCoordinator {
    private let viewControllerBuilder: ViewControllerBuilder
    private let coordinatorBuilder: CoordinatorBuilder
    private let deeplinkStore: DeeplinkDataStore
    private let analyticsService: AnalyticsServiceInterface
    private let chatService: ChatServiceInterface
    private let configService: AppConfigServiceInterface

    lazy var isEnabled: Bool = {
        configService.isFeatureEnabled(key: .chat)
    }()

    init(navigationController: UINavigationController,
         viewControllerBuilder: ViewControllerBuilder,
         coordinatorBuilder: CoordinatorBuilder,
         deepLinkStore: DeeplinkDataStore,
         analyticsService: AnalyticsServiceInterface,
         chatService: ChatServiceInterface,
         configService: AppConfigServiceInterface) {
        self.viewControllerBuilder = viewControllerBuilder
        self.coordinatorBuilder = coordinatorBuilder
        self.deeplinkStore = deepLinkStore
        self.analyticsService = analyticsService
        self.chatService = chatService
        self.configService = configService
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

        self.set(viewController)
    }

    func route(for url: URL) -> ResolvedDeeplinkRoute? {
        deeplinkStore.route(
            for: url,
            parent: self
        )
    }

    func didReselectTab() { /* To be implemented */ }
}
