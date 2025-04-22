import Foundation
import UIKit
import SwiftUI
import GOVKit

class LocalAuthenticationOnboardingCoordinator: BaseCoordinator {
    private let navigationController: UINavigationController
    private let analyticsService: AnalyticsServiceInterface
    private let localAuthenticationService: LocalAuthenticationServiceInterface
    private let authenticationTokenService: AuthenticationTokenServiceInterface
    private let completionAction: () -> Void

    init(navigationController: UINavigationController,
         analyticsService: AnalyticsServiceInterface,
         localAuthenticationService: LocalAuthenticationServiceInterface,
         authenticationTokenService: AuthenticationTokenServiceInterface,
         completionAction: @escaping () -> Void) {
        self.navigationController = navigationController
        self.localAuthenticationService = localAuthenticationService
        self.authenticationTokenService = authenticationTokenService
        self.analyticsService = analyticsService
        self.completionAction = completionAction
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        switch localAuthenticationService.authType {
        case .faceID, .touchID:
            setLocalAuthenticationOnboardingViewController()
        case .passcodeOnly:
            do {
                try authenticationTokenService.encryptRefreshToken()
                finishCoordination()
            } catch {
                print("Handle error")
            }
        default:
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
            localAuthenticationService: localAuthenticationService,
            authenticationTokenService: authenticationTokenService,
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
