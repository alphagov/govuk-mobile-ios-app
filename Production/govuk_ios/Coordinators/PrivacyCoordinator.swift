import UIKit
import Foundation
import GOVKit

protocol PrivacyPresenting {
    func showPrivacyScreen(appDidTimeout: Bool)
    func hidePrivacyScreen()
}

protocol PrivacyProviding { }

class PrivacyCoordinator: BaseCoordinator {
    init() {
        let navigationController = UINavigationController()
        navigationController.modalPresentationStyle = .fullScreen
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        let view = PrivacyView()
        let viewController = HostingViewController(rootView: view)
        viewController.modalPresentationStyle = .fullScreen
        set(viewController, animated: false)
    }
}

extension PrivacyCoordinator: PrivacyProviding { }
