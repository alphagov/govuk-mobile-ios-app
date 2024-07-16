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
//        print("started onboarding")
//        dismissAction()
//        let onboardingModule = Onboarding(dismissAction: { [weak self] in
//            self?.dismiss(animated: true)
//        }, onboardingSource: .json("OnboardingResponse"))
//        onboardingModule.viewController.modalPresentationStyle = .fullScreen
//        present(onboardingModule.viewController, animated: true)
    }
    }
