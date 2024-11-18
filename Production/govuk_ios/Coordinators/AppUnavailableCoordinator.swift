import Foundation
import UIKit
import SwiftUI

class AppUnavailableCoordinator: BaseCoordinator {
    private let appConfigService: AppConfigServiceInterface
    private let launchResponse: AppLaunchResponse
    private let dismissAction: () -> Void

    init(navigationController: UINavigationController,
         appConfigService: AppConfigServiceInterface,
         launchResponse: AppLaunchResponse,
         dismissAction: @escaping () -> Void) {
        self.appConfigService = appConfigService
        self.launchResponse = launchResponse
        self.dismissAction = dismissAction
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        guard launchResponse.hasErrors ||
              !launchResponse.isAppAvailable
        else { return dismissAction() }
        setAppUnavailable()
    }

    private func setAppUnavailable() {
        let viewModel = AppUnavailableContainerViewModel()
        let containerView = AppUnavailableContainerView(
            viewModel: viewModel
        )
        let viewController = UIHostingController(
            rootView: containerView
        )
        set(viewController)
    }
}
