import Foundation
import UIKit
import SwiftUI
import GOVKit

class WelcomeOnboardingCoordinator: BaseCoordinator {
    private let navigationController: UINavigationController
    private let authenticationService: AuthenticationServiceInterface
    private let analyticsService: AnalyticsServiceInterface
    private let coordinatorBuilder: CoordinatorBuilder
    private let completionAction: () -> Void
    private let newUserAction: (() -> Void)?

    init(navigationController: UINavigationController,
         authenticationService: AuthenticationServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         coordinatorBuilder: CoordinatorBuilder,
         completionAction: @escaping () -> Void,
         newUserAction: (() -> Void)?) {
        self.navigationController = navigationController
        self.authenticationService = authenticationService
        self.analyticsService = analyticsService
        self.coordinatorBuilder = coordinatorBuilder
        self.completionAction = completionAction
        self.newUserAction = newUserAction
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        guard !shouldSkipOnboarding else {
            finishCoordination()
            return
        }

        setWelcomeOnboardingViewController()
    }

    private func setWelcomeOnboardingViewController(_ animated: Bool = true) {
        let viewModel = WelcomeOnboardingViewModel(
            analyticsService: analyticsService,
            completeAction: { [weak self] in
                Task {
                    await self?.authenticateAction()
                }
            }
        )
        let containerView = WelcomeOnboardingView(
            viewModel: viewModel
        )
        let viewController = UIHostingController(
            rootView: containerView
        )
        set(viewController)
    }

    private func finishCoordination() {
        DispatchQueue.main.async {
            self.completionAction()
        }
    }

    private func authenticateAction() async {
        let authenticationCoordinator = coordinatorBuilder.authentication(
            navigationController: navigationController,
            completionAction: completionAction,
            newUserAction: newUserAction,
            handleError: showError
        )
        start(authenticationCoordinator)
    }

    func showError(_ error: AuthenticationError) {
        guard case .loginFlow(.userCancelled) = error else {
            let errorCoordinator = coordinatorBuilder.signInError(
                navigationController: root,
                completion: { [weak self] in
                    self?.setWelcomeOnboardingViewController(false)
                }
            )
            start(errorCoordinator)
            return
        }
    }

    private var shouldSkipOnboarding: Bool {
        authenticationService.isSignedIn
    }
}
