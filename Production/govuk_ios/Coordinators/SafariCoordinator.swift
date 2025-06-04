import Foundation
import UIKit
import GOVKit
import SafariServices

class SafariCoordinator: BaseCoordinator {
    private let viewControllerBuilder: ViewControllerBuilder
    private let configService: AppConfigServiceInterface
    private let urlOpener: URLOpener
    private let url: URL

    init(navigationController: UINavigationController,
         viewControllerBuilder: ViewControllerBuilder,
         configService: AppConfigServiceInterface,
         urlOpener: URLOpener,
         url: URL) {
        self.viewControllerBuilder = viewControllerBuilder
        self.configService = configService
        self.urlOpener = urlOpener
        self.url = url
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        if configService.isFeatureEnabled(key: .externalBrowser) {
            urlOpener.openIfPossible(self.url)
        } else {
            presentViewController(url: self.url)
        }
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
