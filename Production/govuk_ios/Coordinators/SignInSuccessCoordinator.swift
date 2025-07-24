import SwiftUI
import GOVKit

final class SignInSuccessCoordinator: BaseCoordinator {
    private let analyticsService: AnalyticsServiceInterface
    private let authenticationService: AuthenticationServiceInterface
    private let completion: () -> Void

    init(navigationController: UINavigationController,
         analyticsService: AnalyticsServiceInterface,
         authenticationService: AuthenticationServiceInterface,
         completion: @escaping () -> Void) {
        self.analyticsService = analyticsService
        self.authenticationService = authenticationService
        self.completion = completion
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        let viewModel = SignInSuccessViewModel(
            completion: { [weak self] in
                self?.completion()
            }
        )

        let containerView = InfoView(
            viewModel: viewModel
        )
        let viewController = UIHostingController(
            rootView: containerView
        )
        set(viewController)
    }
}
