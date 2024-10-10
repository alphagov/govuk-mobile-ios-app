import Foundation
import UIKit
import SwiftUI

class AppRecommendUpdateCoordinator: BaseCoordinator {
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
        guard appConfigService.isAppRecommendUpdate
        else { return dismissAction() }
        setAppRecommendUpdate()
    }

    private func setAppRecommendUpdate() {
        let viewModel = AppRecommendUpdateContainerViewModel(dismissAction: dismissAction)
        let containerView = AppRecommendUpdateContainerView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: containerView)
        set(viewController)
    }
}
