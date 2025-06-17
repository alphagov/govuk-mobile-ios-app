import Foundation
import UIKit
import GOVKit
import SafariServices

class SafariCoordinator: BaseCoordinator {
    private let presentingViewController: UIViewController
    private let viewControllerBuilder: ViewControllerBuilder
    private let configService: AppConfigServiceInterface
    private let urlOpener: URLOpener
    private let url: URL
    private let fullScreen: Bool

    init(presentingViewController: UIViewController,
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
        self.presentingViewController = presentingViewController
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
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
        root.setViewControllers([viewController], animated: false)
        if fullScreen {
            root.modalPresentationStyle = .fullScreen
        } else {
            root.modalPresentationStyle = .formSheet
        }
        presentingViewController.present(root, animated: true)
    }
}
