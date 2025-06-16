import Foundation
import UIKit
import GOVKit
import UIComponents

class NotificationsOnboardingViewModel: ObservableObject {
    let analyticsService: AnalyticsServiceInterface
    let completeAction: () -> Void
    let openAction: (URL) -> Void
    let dismissAction: () -> Void
    let showImage: Bool

    init(analyticsService: AnalyticsServiceInterface,
         showImage: Bool,
         openAction: @escaping (URL) -> Void = { UIApplication.shared.open($0) },
         completeAction: @escaping () -> Void,
         dismissAction: @escaping () -> Void) {
        self.analyticsService = analyticsService
        self.showImage = showImage
        self.openAction = openAction
        self.completeAction = completeAction
        self.dismissAction = dismissAction
    }

    let title: String = String.notifications.localized(
        "onboardingTitle"
    )
    let body: String = String.notifications.localized("onboardingBody")
    let privacyPolicyLinkTitle: String = String.notifications.localized(
        "onboardingPrivacyButtonTitle"
    )

    var primaryButtonViewModel: GOVUKButton.ButtonViewModel {
        let localTitle = String.notifications.localized("onboardingAcceptButtonTitle")
        return .init(
            localisedTitle: localTitle,
            action: { [weak self] in
                self?.trackButtonActionEvent(title: localTitle)
                self?.completeAction()
            }
        )
    }

    var secondaryButtonViewModel: GOVUKButton.ButtonViewModel {
        let localTitle = String.notifications.localized("onboardingSkipButtonTitle")
        return .init(
            localisedTitle: localTitle,
            action: { [weak self] in
                self?.trackButtonActionEvent(title: localTitle)
                self?.dismissAction()
            }
        )
    }

    func openPrivacyPolicy() {
        openAction(Constants.API.privacyPolicyUrl)
    }

    private func trackButtonActionEvent(title: String) {
        let event = AppEvent.buttonNavigation(text: title, external: false)
        analyticsService.track(event: event)
    }
}
