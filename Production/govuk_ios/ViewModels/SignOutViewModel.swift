import Foundation
import GOVKit
import UIComponents

final class SignOutViewModel {
    let bulletStrings: [String] = [String.signOut.localized("signOutBulletOne"),
                                   String.signOut.localized("signOutBulletTwo")]
    let title: String = String.signOut.localized("signOutTitle")
    let subTitle: String = String.signOut.localized("signOutSubtitle")
    let body: String = String.signOut.localized("signOutBody")

    private let analyticsService: AnalyticsServiceInterface
    private let completion: () -> Void

    init(analyticsService: AnalyticsServiceInterface,
         completion: @escaping () -> Void) {
        self.analyticsService = analyticsService
        self.completion = completion
    }

    var signOutButtonViewModel: GOVUKButton.ButtonViewModel {
        .init(
            localisedTitle: String.signOut.localized("signOutButtonTitle"),
            action: { [weak self] in
                self?.completion()
//                self?.analyticsService?.setAcceptedAnalytics(accepted: true)
//                self?.finishAnalyticsConsent()
            }
        )
    }

    var cancelButtonViewModel: GOVUKButton.ButtonViewModel {
        .init(
            localisedTitle: String.common.localized("cancel"),
            action: { [weak self] in
                self?.completion()
//                self?.analyticsService?.setAcceptedAnalytics(accepted: false)
//                self?.finishAnalyticsConsent()
            }
        )
    }
}
