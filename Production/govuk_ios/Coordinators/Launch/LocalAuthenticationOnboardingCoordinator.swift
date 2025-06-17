import Foundation
import UIKit
import SwiftUI
import GOVKit

class LocalAuthenticationOnboardingCoordinator: BaseCoordinator {
    private let navigationController: UINavigationController
    private let userDefaults: UserDefaultsInterface
    private let analyticsService: AnalyticsServiceInterface
    private let localAuthenticationService: LocalAuthenticationServiceInterface
    private let authenticationService: AuthenticationServiceInterface
    private let completionAction: () -> Void

    init(navigationController: UINavigationController,
         userDefaults: UserDefaultsInterface,
         analyticsService: AnalyticsServiceInterface,
         localAuthenticationService: LocalAuthenticationServiceInterface,
         authenticationService: AuthenticationServiceInterface,
         completionAction: @escaping () -> Void) {
        self.navigationController = navigationController
        self.userDefaults = userDefaults
        self.localAuthenticationService = localAuthenticationService
        self.authenticationService = authenticationService
        self.analyticsService = analyticsService
        self.completionAction = completionAction
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        guard !localAuthenticationService.authenticationOnboardingFlowSeen else {
            finishCoordination()
            return
        }

        if localAuthenticationService.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics) {
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
            userDefaults: userDefaults,
            localAuthenticationService: localAuthenticationService,
            authenticationService: authenticationService,
            analyticsService: analyticsService,
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
