import Foundation
import UIKit

class WebViewCoordinator: BaseCoordinator {
    private let viewControllerBuilder: ViewControllerBuilder
    private let url: URL

    init(navigationController: UINavigationController,
         viewControllerBuilder: ViewControllerBuilder,
         url: URL) {
        self.viewControllerBuilder = viewControllerBuilder
        self.url = url
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        setDeeplinkPage()
    }

    @MainActor
    private func setDeeplinkPage() {
        let viewController = viewControllerBuilder.webViewController(for: url)
        root.setViewControllers([viewController], animated: false)
    }
}
