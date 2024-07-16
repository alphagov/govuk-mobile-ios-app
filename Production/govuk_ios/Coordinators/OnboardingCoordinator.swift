import Foundation
import UIKit
import Onboarding

class OnboardingCoordinator: BaseCoordinator {
    private let dismissAction: () -> Void

    init(navigationController: UINavigationController,
         dismissAction: @escaping () -> Void) {
         self.dismissAction = dismissAction
         super.init(navigationController: navigationController)
    }

    override func start() {
        let onboardingModule = Onboarding(source: .json("OnboardingResponse")) { [weak self] in
            self?.dismissAction()
        }
        onboardingModule.viewController.modalPresentationStyle = .fullScreen
        set(onboardingModule.viewController)
    }
}
