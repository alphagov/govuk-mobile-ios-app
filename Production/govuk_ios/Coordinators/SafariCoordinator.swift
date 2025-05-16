import Foundation
import UIKit
import SafariServices

class SafariCoordinator: BaseCoordinator {
    private let url: URL

    init(navigationController: UINavigationController,
         url: URL) {
        self.url = url
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        presentViewController(url: self.url)
    }

    private func presentViewController(url: URL) {
        let config = SFSafariViewController.Configuration()
        config.barCollapsingEnabled = true
        let viewController = SFSafariViewController(
            url: url,
            configuration: config
        )
        viewController.modalPresentationStyle = .formSheet
        viewController.isModalInPresentation = true
        let navigationController = UINavigationController(
            rootViewController: viewController
        )
        navigationController.presentationController?.delegate = self
        root.present(navigationController, animated: true)
        navigationController.isNavigationBarHidden = true
    }
}
