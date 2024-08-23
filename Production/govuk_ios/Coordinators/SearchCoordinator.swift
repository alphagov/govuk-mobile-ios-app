import UIKit
import Foundation

class SearchCoordinator: BaseCoordinator {
    private let viewControllerBuilder: ViewControllerBuilder

    init(navigationController: UINavigationController,
         viewControllerBuilder: ViewControllerBuilder) {
        self.viewControllerBuilder = viewControllerBuilder
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        let viewController = viewControllerBuilder.search()
        viewController.modalPresentationStyle = .pageSheet

        set(viewController, animated: true)
    }
}
