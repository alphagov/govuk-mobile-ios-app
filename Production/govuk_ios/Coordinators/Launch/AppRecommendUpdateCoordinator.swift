import Foundation
import UIKit
import SwiftUI

class AppRecommendUpdateCoordinator: BaseCoordinator {
    private let launchResponse: AppLaunchResponse
    private let dismissAction: () -> Void

    init(navigationController: UINavigationController,
         launchResponse: AppLaunchResponse,
         dismissAction: @escaping () -> Void) {
        self.launchResponse = launchResponse
        self.dismissAction = dismissAction
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        guard launchResponse.isUpdateRecommended
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
