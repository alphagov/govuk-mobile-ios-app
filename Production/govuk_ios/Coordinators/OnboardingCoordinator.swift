import Foundation
import UIKit
import Onboarding

class OnboardingCoordinator: BaseCoordinator {
    private let userDefaults: OnboardingPersistanceInterface
    private let dismissAction: () -> Void

    init(navigationController: UINavigationController,
         userDefaults: OnboardingPersistanceInterface,
         dismissAction: @escaping () -> Void) {
        self.dismissAction = dismissAction
        self.userDefaults = userDefaults
        navigationController.modalPresentationStyle = .fullScreen
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        guard userDefaults.hasOnboarded(forKey: .hasOnboarded) == false
        else { return dismissAction() }
        setOnboarding()
    }

    private func setOnboarding() {
        let onboardingModule = Onboarding(
            source: .model(slides),
            dismissAction: { [weak self] in
                self?.userDefaults.setFlag(forkey: .hasOnboarded, to: true)
                self?.dismissAction()
            }
        )
        set(onboardingModule.viewController)
    }

    private var slides: [OnboardingSlide] {
        return [
            .init(
                image: "onboarding_placeholder_screen_1",
                title: "Get things done on the go",
                body: """
                Access government services and information on your phone using the GOV.UK app
                """
            ),
            .init(
                image: "onboarding_placeholder_screen_2",
                title: "Quickly get back to previous pages",
                body: """
                Pages you’ve visited are saved so you can easily return to them
                """
            ),
            .init(
                image: "onboarding_placeholder_screen_3",
                title: "Tailored to you",
                body: """
                Choose topics that are relevant to you so you can find what you need faster
                """
            )
        ]
    }
}
