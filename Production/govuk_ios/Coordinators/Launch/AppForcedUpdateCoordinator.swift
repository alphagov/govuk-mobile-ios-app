import Foundation
import UIKit
import SwiftUI

class AppForcedUpdateCoordinator: BaseCoordinator {
    private let launchResponse: AppLaunchResponse
    private let dismissAction: () -> Void

    init(navigationController: UINavigationController,
         launchResponse: AppLaunchResponse,
         dismissAction: @escaping () -> Void) {
        self.dismissAction = dismissAction
        self.launchResponse = launchResponse
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        guard launchResponse.isUpdateRequired
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
