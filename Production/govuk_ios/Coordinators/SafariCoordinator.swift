import Foundation
import UIKit
import GOVKit
import SafariServices

class SafariCoordinator: BaseCoordinator {
    private let viewControllerBuilder: ViewControllerBuilder
    private let configService: AppConfigServiceInterface
    private let urlOpener: URLOpener
    private let url: URL
    private let fullScreen: Bool

    init(navigationController: UINavigationController,
         viewControllerBuilder: ViewControllerBuilder,
         configService: AppConfigServiceInterface,
         urlOpener: URLOpener,
         url: URL,
         fullScreen: Bool) {
        self.viewControllerBuilder = viewControllerBuilder
        self.configService = configService
        self.urlOpener = urlOpener
        self.url = url
        self.fullScreen = fullScreen
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
        viewController.modalPresentationStyle = fullScreen ? .fullScreen : .pageSheet
        viewController.isModalInPresentation = true
        let presentedViewController = root.presentedViewController ?? root
        presentedViewController.present(viewController, animated: true)
    }
}
