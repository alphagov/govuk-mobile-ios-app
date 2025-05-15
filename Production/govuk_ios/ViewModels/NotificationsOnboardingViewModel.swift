import Foundation
import GOVKit
import UIComponents

class NotificationsOnboardingViewModel: ObservableObject {
    let urlOpener: URLOpener
    let analyticsService: AnalyticsServiceInterface
    let completeAction: () -> Void
    let dismissAction: () -> Void

    init(urlOpener: URLOpener,
         analyticsService: AnalyticsServiceInterface,
         completeAction: @escaping () -> Void,
         dismissAction: @escaping () -> Void) {
        self.urlOpener = urlOpener
        self.analyticsService = analyticsService
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
        urlOpener.openPrivacyPolicy()
    }

    private func trackButtonActionEvent(title: String) {
        let event = AppEvent.buttonNavigation(text: title, external: false)
        analyticsService.track(event: event)
    }
}
