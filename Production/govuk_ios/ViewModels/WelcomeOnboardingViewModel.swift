import Foundation
import GOVKit
import UIComponents

class WelcomeOnboardingViewModel: ObservableObject {
    let analyticsService: AnalyticsServiceInterface
    let completeAction: () -> Void

    init(analyticsService: AnalyticsServiceInterface,
         completeAction: @escaping () -> Void) {
        self.analyticsService = analyticsService
        self.completeAction = completeAction
    }

    let title: String = String.onboarding.localized(
        "welcomeTitle"
    )

    let body: String = String.onboarding.localized(
        "welcomeBody"
    )

    var primaryButtonViewModel: GOVUKButton.ButtonViewModel {
        let localTitle = String.onboarding.localized("welcomeButtonTitle")
        return .init(
            localisedTitle: localTitle,
            action: { [weak self] in
                self?.trackButtonActionEvent(title: localTitle)
                self?.completeAction()
            }
        )
    }

    private func trackButtonActionEvent(title: String) {
        let event = AppEvent.buttonNavigation(text: title, external: false)
        analyticsService.track(event: event)
    }
}
