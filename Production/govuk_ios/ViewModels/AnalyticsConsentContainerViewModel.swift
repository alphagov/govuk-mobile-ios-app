import Foundation
import UIComponents
import UIKit
import GOVKit

class AnalyticsConsentContainerViewModel: ObservableObject {
    private let analyticsService: AnalyticsServiceInterface?
    private let urlOpener: URLOpener
    private let completion: () -> Void

    let title = String.onboarding.localized("analyticsConsentTitle")
    let descriptionTop = String.onboarding.localized("analyticsConsentDescriptionTop")
    let descriptionBullets = String.onboarding.localized("analyticsConsentDescriptionBullets")
    let descriptionBottom = String.onboarding.localized("analyticsConsentDescriptionBottom")
    let privacyPolicyLinkTitle = String.onboarding.localized("privacyPolicyLinkTitle")
    let privacyPolicyLinkAccessibilityTitle =
    String.onboarding.localized("privacyPolicyLinkAccessibilityTitle")
    let privacyPolicyLinkHint = String.common.localized("openWebLinkHint")
    let privacyPolicyLinkUrl = Constants.API.privacyPolicyUrl
    let allowButtonTitle = String.onboarding.localized("allowAnalyticsButtonTitle")
    let dontAllowButtonTitle = String.onboarding.localized("dontAllowAnalyticsButtonTitle")

    var allowButtonViewModel: GOVUKButton.ButtonViewModel {
        .init(
            localisedTitle: allowButtonTitle,
            action: { [weak self] in
                self?.analyticsService?.setAcceptedAnalytics(accepted: true)
                self?.finishAnalyticsConsent()
            }
        )
    }

    var dontAllowButtonViewModel: GOVUKButton.ButtonViewModel {
        .init(
            localisedTitle: dontAllowButtonTitle,
            action: { [weak self] in
                self?.analyticsService?.setAcceptedAnalytics(accepted: false)
                self?.finishAnalyticsConsent()
            }
        )
    }

    init(analyticsService: AnalyticsServiceInterface?,
         urlOpener: URLOpener = UIApplication.shared,
         completion: @escaping () -> Void) {
        self.analyticsService = analyticsService
        self.urlOpener = urlOpener
        self.completion = completion
    }

    func openPrivacyPolicy() {
        urlOpener.openIfPossible(privacyPolicyLinkUrl)
    }

    private func finishAnalyticsConsent() {
        completion()
    }
}
