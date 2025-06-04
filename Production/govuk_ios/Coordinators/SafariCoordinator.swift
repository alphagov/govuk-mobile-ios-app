import Foundation
import UIKit
import SafariServices

class SafariCoordinator: BaseCoordinator {
    private let url: URL
    private let viewControllerBuilder: ViewControllerBuilder
    private let fullScreen: Bool

    init(navigationController: UINavigationController,
         viewControllerBuilder: ViewControllerBuilder,
         url: URL, fullScreen: Bool) {
        self.url = url
        self.viewControllerBuilder = viewControllerBuilder
        self.fullScreen = fullScreen
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
        if fullScreen {
            root.present(navigationController, animated: true)
        }
    }
}
