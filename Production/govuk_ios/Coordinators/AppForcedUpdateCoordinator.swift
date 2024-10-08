import Foundation
import UIKit
import SwiftUI

class AppForcedUpdateCoordinator: BaseCoordinator {
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
        guard appConfigService.isAppForcedUpdate
        else { return dismissAction() }
        setAppForcedUpdate()
    }

    private func setAppForcedUpdate() {
        let viewModel = AppForcedUpdateContainerViewModel()
        let containerView = AppForcedUpdateContainerView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: containerView)
        set(viewController)
    }
}
