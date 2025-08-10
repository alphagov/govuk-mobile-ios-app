import Foundation
import UIKit
import GOVKit

class ChatCoordinator: TabItemCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder
    private let viewControllerBuilder: ViewControllerBuilder
    private let deeplinkStore: DeeplinkDataStore
    private let analyticsService: AnalyticsServiceInterface
    private let chatService: ChatServiceInterface
    private let cancelOnboardingAction: () -> Void
    private var isShowingError = false
    private lazy var chatViewController: UIViewController = {
        viewControllerBuilder.chat(
            analyticsService: analyticsService,
            chatService: chatService,
            openURLAction: presentWebView,
            handleError: handleError
        )
    }()

    var isEnabled: Bool {
        chatService.isEnabled
    }

    init(navigationController: UINavigationController,
         coordinatorBuilder: CoordinatorBuilder,
         viewControllerBuilder: ViewControllerBuilder,
         deepLinkStore: DeeplinkDataStore,
         analyticsService: AnalyticsServiceInterface,
         chatService: ChatServiceInterface,
         cancelOnboardingAction: @escaping () -> Void) {
        self.coordinatorBuilder = coordinatorBuilder
        self.viewControllerBuilder = viewControllerBuilder
        self.deeplinkStore = deepLinkStore
        self.analyticsService = analyticsService
        self.chatService = chatService
        self.cancelOnboardingAction = cancelOnboardingAction
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        set(chatViewController)
        isShowingError = false
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
    func didSelectTab(_ selectedTabIndex: Int,
                      previousTabIndex: Int) {
        if selectedTabIndex != previousTabIndex &&
            isShowingError {
            set(chatViewController, animated: false)
            isShowingError = false
        } else if !chatService.chatOnboardingSeen {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.present(
                    coordinatorBuilder.chatInfoOnboarding(
                        cancelOnboardingAction: cancelOnboardingAction
                    )
                )
            }
        } else {
            set(chatViewController, animated: false)
        }
    }

    private func handleError(_ error: ChatError) {
        let viewController = viewControllerBuilder.chatError(
            error: error,
            action: { [weak self] in
                guard let self else { return }
                switch error {
                case .networkUnavailable:
                    self.set(
                        self.chatViewController,
                        animated: false
                    )
                case .pageNotFound:
                    self.chatService.clearHistory()
                    self.set(
                        self.chatViewController,
                        animated: false
                    )
                default:
                    break
                }
            }
        )
        set(viewController, animated: false)
        isShowingError = true
    }
}
