import Foundation
import UIKit
import GOVKit

class ChatCoordinator: TabItemCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder
    private let viewControllerBuilder: ViewControllerBuilder
    private let deeplinkStore: DeeplinkDataStore
    private let analyticsService: AnalyticsServiceInterface
    private let chatService: ChatServiceInterface
    private let authenticationService: AuthenticationServiceInterface
    private let cancelOnboardingAction: () -> Void
    var isShowingError = false
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
         authenticationService: AuthenticationServiceInterface,
         cancelOnboardingAction: @escaping () -> Void) {
        self.coordinatorBuilder = coordinatorBuilder
        self.viewControllerBuilder = viewControllerBuilder
        self.deeplinkStore = deepLinkStore
        self.analyticsService = analyticsService
        self.chatService = chatService
        self.authenticationService = authenticationService
        self.cancelOnboardingAction = cancelOnboardingAction
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        guard chatService.chatOnboardingSeen else { return }

        setChatViewController()
        isShowingError = false
    }

    func route(for url: URL) -> ResolvedDeeplinkRoute? {
        if !chatService.chatOnboardingSeen {
            showChatOnboarding()
        }
        return deeplinkStore.route(
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

    private func reauthenticate() {
        Task {
            let result = await authenticationService.tokenRefreshRequest()
            switch result {
            case .success:
                self.chatService.retryAction?()
            case .failure:
                self.authenticationService.signOut(reason: .tokenRefreshFailure)
            }
        }
    }

    func didReselectTab() { /* To be implemented */ }
    func didSelectTab(_ selectedTabIndex: Int,
                      previousTabIndex: Int) {
        if !chatService.chatOnboardingSeen {
            showChatOnboarding()
        } else if selectedTabIndex != previousTabIndex && isShowingError {
            setChatViewController()
            isShowingError = false
        }
    }

    private func showChatOnboarding() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            present(
                coordinatorBuilder.chatInfoOnboarding(
                    cancelOnboardingAction: cancelOnboardingAction,
                    setChatViewControllerAction: setChatViewController
                )
            )
        }
    }

    private func handleError(_ error: ChatError) {
        if error == .authenticationError &&
            !chatService.isRetryAction {
            reauthenticate()
        } else {
            setChatError(error)
        }
    }

    private func setChatError(_ error: ChatError) {
        let viewController = viewControllerBuilder.chatError(
            analyticsService: analyticsService,
            error: error,
            action: { [weak self] in
                guard let self else { return }
                switch error {
                case .networkUnavailable:
                    self.setChatViewController()
                case .pageNotFound:
                    self.chatService.clearHistory()
                    self.setChatViewController()
                default:
                    break
                }
            }
        )
        set(viewController, animated: false)
        isShowingError = true
    }

    private func setChatViewController(animated: Bool = false) {
        set(chatViewController, animated: animated)
    }
}
