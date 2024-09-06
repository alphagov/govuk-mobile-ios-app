import Foundation
import UIComponents
import UIKit

class AnalyticsConsentContainerViewModel: ObservableObject {
    private let analyticsService: AnalyticsServiceInterface?
    private let urlOpener: URLOpening
    private let dismissAction: () -> Void

    init(analyticsService: AnalyticsServiceInterface?,
         urlOpener: URLOpening = UIApplication.shared,
         dismissAction: @escaping () -> Void) {
        self.analyticsService = analyticsService
        self.urlOpener = urlOpener
        self.dismissAction = dismissAction
    }

    let title = NSLocalizedString("analyticsConsentTitle", comment: "")

    let descriptionTop = NSLocalizedString("analyticsConsentDescriptionTop", comment: "")

    let descriptionBullets = NSLocalizedString("analyticsConsentDescriptionBullets", comment: "")

    let descriptionBottom = NSLocalizedString("analyticsConsentDescriptionBottom", comment: "")

    let privacyPolicyLinkTitle = NSLocalizedString("privacyPolicyLinkTitle", comment: "")

    let privacyPolicyLinkHint = NSLocalizedString("privacyPolicyLinkHint", comment: "")

    let privacyPolicyLinkUrl = NSLocalizedString("privacyPolicyLinkUrl", comment: "")

    func onPrivacyPolicyLinkClicked() {
        guard let url = URL(string: privacyPolicyLinkUrl) else { return }
        if urlOpener.canOpenURL(url) {
            urlOpener.open(url, options: [:], completionHandler: nil)
        }
    }

    let allowButtonTitle = NSLocalizedString("allowAnalyticsButtonTitle", comment: "")

    var allowButtonViewModel: GOVUKButton.ButtonViewModel {
        .init(
            localisedTitle: allowButtonTitle,
            action: { [weak self] in
                self?.analyticsService?.setAcceptedAnalytics(accepted: true)
                self?.finishAnalyticsConsent()
            }
        )
    }

    let dontAllowButtonTitle = NSLocalizedString("dontAllowAnalyticsButtonTitle", comment: "")

    var dontAllowButtonViewModel: GOVUKButton.ButtonViewModel {
        .init(
            localisedTitle: dontAllowButtonTitle,
            action: { [weak self] in
                self?.analyticsService?.setAcceptedAnalytics(accepted: false)
                self?.finishAnalyticsConsent()
            }
        )
    }

    private func finishAnalyticsConsent() {
        dismissAction()
    }
}
