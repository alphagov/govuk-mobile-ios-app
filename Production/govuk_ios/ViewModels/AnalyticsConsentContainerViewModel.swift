import Foundation
import UIComponents
import UIKit

class AnalyticsConsentContainerViewModel: ObservableObject {
    private let analyticsService: AnalyticsServiceInterface?
    private let urlOpener: URLOpener
    private let dismissAction: () -> Void

    let title = NSLocalizedString("analyticsConsentTitle", comment: "")
    let descriptionTop = NSLocalizedString("analyticsConsentDescriptionTop", comment: "")
    let descriptionBullets = NSLocalizedString("analyticsConsentDescriptionBullets", comment: "")
    let descriptionBottom = NSLocalizedString("analyticsConsentDescriptionBottom", comment: "")
    let privacyPolicyLinkTitle = NSLocalizedString("privacyPolicyLinkTitle", comment: "")
    let privacyPolicyLinkAccessibilityTitle =
    NSLocalizedString("privacyPolicyLinkAccessibilityTitle", comment: "")
    let privacyPolicyLinkHint = NSLocalizedString("privacyPolicyLinkHint", comment: "")
    let privacyPolicyLinkUrl = Constants.API.privacyPolicyUrl
    let allowButtonTitle = NSLocalizedString("allowAnalyticsButtonTitle", comment: "")
    let dontAllowButtonTitle = NSLocalizedString("dontAllowAnalyticsButtonTitle", comment: "")

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
         dismissAction: @escaping () -> Void) {
        self.analyticsService = analyticsService
        self.urlOpener = urlOpener
        self.dismissAction = dismissAction
    }

    func openPrivacyPolicy() {
        urlOpener.openIfPossible(privacyPolicyLinkUrl)
    }

    private func finishAnalyticsConsent() {
        dismissAction()
    }
}
