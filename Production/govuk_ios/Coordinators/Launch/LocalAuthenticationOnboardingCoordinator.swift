import Foundation
import UIKit
import SwiftUI
import GOVKit

class LocalAuthenticationOnboardingCoordinator: BaseCoordinator {
    private let navigationController: UINavigationController
    private let userDefaultsService: UserDefaultsServiceInterface
    private let localAuthenticationService: LocalAuthenticationServiceInterface
    private let authenticationService: AuthenticationServiceInterface
    private let completionAction: () -> Void

    init(navigationController: UINavigationController,
         userDefaultsService: UserDefaultsServiceInterface,
         localAuthenticationService: LocalAuthenticationServiceInterface,
         authenticationService: AuthenticationServiceInterface,
         completionAction: @escaping () -> Void) {
        self.navigationController = navigationController
        self.userDefaultsService = userDefaultsService
        self.localAuthenticationService = localAuthenticationService
        self.authenticationService = authenticationService
        self.completionAction = completionAction
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        guard !localAuthenticationService.authenticationOnboardingFlowSeen else {
            finishCoordination()
            return
        }

        if localAuthenticationService.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics
        ).canEvaluate {
            setLocalAuthenticationOnboardingViewController()
        } else {
            localAuthenticationService.setLocalAuthenticationOnboarded()
            finishCoordination()
        }
    }

    private func finishCoordination() {
        DispatchQueue.main.async {
            self.completionAction()
        }
    }

    private func setLocalAuthenticationOnboardingViewController() {
        let viewModel = LocalAuthenticationOnboardingViewModel(
            userDefaultsService: userDefaultsService,
            localAuthenticationService: localAuthenticationService,
            authenticationService: authenticationService,
            completionAction: finishCoordination
        )
        let containerView = LocalAuthenticationOnboardingView(
            viewModel: viewModel
        )
        let viewController = UIHostingController(
            rootView: containerView
        )
        set(viewController)
    }
}
