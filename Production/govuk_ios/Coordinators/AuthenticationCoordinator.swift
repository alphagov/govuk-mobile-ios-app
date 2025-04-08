import Foundation
import UIKit

class AuthenticationCoordinator: BaseCoordinator {
    private let authenticationService: AuthenticationServiceInterface
    var completionAction: () -> Void

    init(navigationController: UINavigationController,
         authenticationService: AuthenticationServiceInterface,
         completionAction: @escaping () -> Void) {
        self.authenticationService = authenticationService
        self.completionAction = completionAction
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        Task {
            await authenticate()
        }
    }

    private func authenticate() async {
        guard let window = UIApplication.shared.window else {
            return
        }

        await authenticationService.authenticate(
            window: window,
            completion: { [weak self] result in
                switch result {
                case .success(let response):
                    print("\(response)")
                    self?.completionAction()
                case .failure(let error):
                    print("\(error)")
                }
            }
        )
    }
}
