import Foundation
import UIKit
import SafariServices

class SafariCoordinator: BaseCoordinator {
    private let url: URL
    private let viewControllerBuilder: ViewControllerBuilder

    init(navigationController: UINavigationController,
         viewControllerBuilder: ViewControllerBuilder,
         url: URL) {
        self.url = url
        self.viewControllerBuilder = viewControllerBuilder
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        presentViewController(url: self.url)
    }

    private func presentViewController(url: URL) {
        let viewController = viewControllerBuilder.safari(url: url)
        let navigationController = UINavigationController(
            rootViewController: viewController
        )
        navigationController.isNavigationBarHidden = true
        root.present(navigationController, animated: true)
    }
}
