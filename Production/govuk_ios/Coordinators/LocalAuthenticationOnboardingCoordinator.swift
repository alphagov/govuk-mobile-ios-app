import Foundation
import UIKit
import SwiftUI
import GOVKit

class LocalAuthenticationOnboardingCoordinator: BaseCoordinator {
    private let navigationController: UINavigationController
    private let analyticsService: AnalyticsServiceInterface
    private let localAuthenticationService: LocalAuthenticationServiceInterface
    private let authenticationService: AuthenticationServiceInterface
    private let completionAction: () -> Void

    init(navigationController: UINavigationController,
         analyticsService: AnalyticsServiceInterface,
         localAuthenticationService: LocalAuthenticationServiceInterface,
         authenticationService: AuthenticationServiceInterface,
         completionAction: @escaping () -> Void) {
        self.navigationController = navigationController
        self.localAuthenticationService = localAuthenticationService
        self.authenticationService = authenticationService
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
                try authenticationService.encryptRefreshToken()
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
