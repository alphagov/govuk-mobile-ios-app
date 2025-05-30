import Foundation
import UIKit
import Authentication

class AuthenticationCoordinator: BaseCoordinator {
    private let authenticationService: AuthenticationServiceInterface
    private let localAuthenticationService: LocalAuthenticationServiceInterface
    private let completionAction: () -> Void
    private let handleError: (AuthenticationError) -> Void

    init(navigationController: UINavigationController,
         authenticationService: AuthenticationServiceInterface,
         localAuthenticationService: LocalAuthenticationServiceInterface,
         completionAction: @escaping () -> Void,
         handleError: @escaping (AuthenticationError) -> Void) {
        self.authenticationService = authenticationService
        self.localAuthenticationService = localAuthenticationService
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
        case .success:
            if shouldEncryptRefreshToken {
                authenticationService.encryptRefreshToken()
            }
            DispatchQueue.main.async {
                self.completionAction()
            }
        case .failure(let error):
            DispatchQueue.main.async {
                self.handleError(error)
            }
        }
    }

    private var shouldEncryptRefreshToken: Bool {
        localAuthenticationService.authenticationOnboardingFlowSeen &&
        localAuthenticationService.isLocalAuthenticationEnabled
    }
}
