import Foundation
import UIComponents
import UIKit

class AnalyticsConsentContainerViewModel: ObservableObject {
    private let analyticsService: AnalyticsServiceInterface?
    private let urlOpener: URLOpener
    private let dismissAction: () -> Void

    let title = "analyticsConsentTitle".localized
    let descriptionTop = "analyticsConsentDescriptionTop".localized
    let descriptionBullets = "analyticsConsentDescriptionBullets".localized
    let descriptionBottom = "analyticsConsentDescriptionBottom".localized
    let privacyPolicyLinkTitle = "privacyPolicyLinkTitle".localized
    let privacyPolicyLinkAccessibilityTitle =
        "privacyPolicyLinkAccessibilityTitle".localized
    let privacyPolicyLinkHint = "openWebLinkHint".localized
    let privacyPolicyLinkUrl = Constants.API.privacyPolicyUrl
    let dontAllowButtonTitle = "dontAllowAnalyticsButtonTitle".localized
    let allowButtonTitle = "allowAnalyticsButtonTitle".localized

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
