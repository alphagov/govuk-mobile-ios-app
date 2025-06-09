import Foundation
import UIKit
import SwiftUI

class AppUnavailableCoordinator: BaseCoordinator {
    private let appLaunchService: AppLaunchServiceInterface
    private let launchResponse: AppLaunchResponse
    let dismissAction: () -> Void

    init(navigationController: UINavigationController,
         appLaunchService: AppLaunchServiceInterface,
         launchResponse: AppLaunchResponse,
         dismissAction: @escaping () -> Void) {
        self.appLaunchService = appLaunchService
        self.launchResponse = launchResponse
        self.dismissAction = dismissAction
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        guard !launchResponse.isAppAvailable
        else { return dismissAction() }
        setAppUnavailable(launchResponse.configResult.getError())
    }

    private func setAppUnavailable(_ error: AppConfigError?) {
        let viewModel = AppUnavailableContainerViewModel(
            appLaunchService: appLaunchService,
            error: error,
            dismissAction: dismissAction
        )
        let containerView = AppUnavailableContainerView(
            viewModel: viewModel
        )
        let viewController = UIHostingController(
            rootView: containerView
        )
        set(viewController)
    }
}
