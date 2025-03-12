import UIKit
import Foundation
import GOVKit
import SecureStore

class TokenCoordinator: BaseCoordinator {
    private let secureStoreService: SecureStorable
    private let viewControllerBuilder: ViewControllerBuilder

    init(navigationController: UINavigationController,
         viewControllerBuilder: ViewControllerBuilder,
         secureStoreService: SecureStorable) {
        self.secureStoreService = secureStoreService
        self.viewControllerBuilder = viewControllerBuilder
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        let viewController = viewControllerBuilder.tokenStore(
            secureStoreService: secureStoreService
        )
        push(viewController, animated: true)
    }
}
