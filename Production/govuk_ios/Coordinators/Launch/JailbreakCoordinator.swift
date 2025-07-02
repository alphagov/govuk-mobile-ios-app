import Foundation
import UIKit
import SwiftUI

class JailbreakCoordinator: BaseCoordinator {
    private let jailbreakDetectionService: JailbreakDetectionServiceInterface
    let dismissAction: () -> Void

    init(navigationController: UINavigationController,
         jailbreakDetectionService: JailbreakDetectionServiceInterface,
         dismissAction: @escaping () -> Void) {
        self.jailbreakDetectionService = jailbreakDetectionService
        self.dismissAction = dismissAction
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        guard jailbreakDetectionService.isJailbroken() else {
            return dismissAction()
        }
        setJailbreakDetectedViewController()
    }

    private func setJailbreakDetectedViewController() {
        let viewModel = AppUnavailableContainerViewModel(
            appLaunchService: nil,
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
