import Foundation
import UIKit

class AuthenticationCoordinator: BaseCoordinator {
    private let authenticationService: AuthenticationServiceInterface
    private let localAuthenticationService: LocalAuthenticationServiceInterface
    private let completionAction: () -> Void

    init(navigationController: UINavigationController,
         authenticationService: AuthenticationServiceInterface,
         localAuthenticationService: LocalAuthenticationServiceInterface,
         completionAction: @escaping () -> Void) {
        self.authenticationService = authenticationService
        self.localAuthenticationService = localAuthenticationService
        self.completionAction = completionAction
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
            print("\(error)")
        }
    }

    private var shouldEncryptRefreshToken: Bool {
        let onboardingFlowSeen = authenticationService.authenticationOnboardingFlowSeen
        let shouldAuthByBiometrics =
        localAuthenticationService.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics)
        let shouldAuthByPasscode =
        !authenticationService.isLocalAuthenticationSkipped &&
        localAuthenticationService.canEvaluatePolicy(.deviceOwnerAuthentication)

        // encrypts refresh token if user has seen onboarding, and either:
        // can evaluate by biometrics (enrolled during onboarding or iOS settings)
        // OR
        // hasn't skipped local authentication + can evaluate by passcode
        return onboardingFlowSeen && (shouldAuthByBiometrics || shouldAuthByPasscode)
    }
}
