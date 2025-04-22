import Foundation
import UIKit

class AuthenticationCoordinator: BaseCoordinator {
    private let authenticationService: AuthenticationServiceInterface
    private let completionAction: () -> Void

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
        guard let window = self.root.view.window else {
            return
        }

        let result = await authenticationService.authenticate(window: window)
        switch result {
        case .success(let response):
            print("\(response)")
            DispatchQueue.main.async {
                self.completionAction()
            }
        case .failure(let error):
            print("\(error)")
        }
    }
}
