import Foundation
import GOVKit
import UIKit
import Authentication

class AuthenticationCoordinator: BaseCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder
    private let authenticationService: AuthenticationServiceInterface
    private let localAuthenticationService: LocalAuthenticationServiceInterface
    private let analyticsService: AnalyticsServiceInterface
    private let topicsService: TopicsServiceInterface
    private let completionAction: () -> Void
    private let handleError: (AuthenticationError) -> Void

    init(navigationController: UINavigationController,
         coordinatorBuilder: CoordinatorBuilder,
         authenticationService: AuthenticationServiceInterface,
         localAuthenticationService: LocalAuthenticationServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         topicsService: TopicsServiceInterface,
         completionAction: @escaping () -> Void,
         handleError: @escaping (AuthenticationError) -> Void) {
        self.coordinatorBuilder = coordinatorBuilder
        self.authenticationService = authenticationService
        self.localAuthenticationService = localAuthenticationService
        self.analyticsService = analyticsService
        self.topicsService = topicsService
        self.completionAction = completionAction
        self.handleError = handleError
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        Task {
            await authenticate()
        }
    }

    private func authenticate() async {
        guard let window = root.view.window else {
            return
        }

        let result = await authenticationService.authenticate(window: window)
        switch result {
        case .success(let response):
            if shouldEncryptRefreshToken {
                authenticationService.encryptRefreshToken()
            }
            handleAnalyticsConsent(response: response)
            handleTopicsViewed(response: response)
            startSignInSuccess()
        case .failure(let error):
            DispatchQueue.main.async {
                self.handleError(error)
            }
        }
    }

    private func handleAnalyticsConsent(response: AuthenticationServiceResponse) {
        if !response.returningUser {
            analyticsService.resetConsent()
        } else {
            analyticsService.setExistingConsent()
        }
    }

    private func handleTopicsViewed(response: AuthenticationServiceResponse) {
        if !response.returningUser {
            topicsService.resetOnboarding()
            localAuthenticationService.resetLocalAuthenticationOnboardingSeen()
        }
    }

    @MainActor
    private func startSignInSuccess() {
        let coordinator = coordinatorBuilder.signInSuccess(
            navigationController: root,
            completion: completionAction
        )
        start(coordinator)
    }

    private var shouldEncryptRefreshToken: Bool {
        localAuthenticationService.authenticationOnboardingFlowSeen
    }
}
