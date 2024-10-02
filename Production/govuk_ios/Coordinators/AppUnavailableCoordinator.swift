import Foundation
import UIKit
import SwiftUI

class AppUnavailableCoordinator: BaseCoordinator {
    private let appConfigService: AppConfigServiceInterface
    private let dismissAction: () -> Void

    init(navigationController: UINavigationController,
         appConfigService: AppConfigServiceInterface,
         dismissAction: @escaping () -> Void) {
        self.appConfigService = appConfigService
        self.dismissAction = dismissAction
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        guard !appConfigService.isAppAvailable
        else { return dismissAction() }
        setAppUnavailable()
    }

    private func setAppUnavailable() {
        let viewModel = AppUnavailableContainerViewModel()
        let containerView = AppUnavailableContainerView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: containerView)
        set(viewController)
    }
}
