import Foundation
import GOVKit
import UIComponents

final class SignOutConfirmationViewModel {
    let bulletStrings: [String] = [String.signOut.localized("signOutBulletOne"),
                                   String.signOut.localized("signOutBulletTwo")]
    let title: String = String.signOut.localized("signOutTitle")
    let subTitle: String = String.signOut.localized("signOutSubtitle")
    let body: String = String.signOut.localized("signOutBody")

    private let analyticsService: AnalyticsServiceInterface
    private let authenticationService: AuthenticationServiceInterface
    private let completion: () -> Void

    init(authenticationService: AuthenticationServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         completion: @escaping () -> Void) {
        self.authenticationService = authenticationService
        self.analyticsService = analyticsService
        self.completion = completion
    }

    var signOutButtonViewModel: GOVUKButton.ButtonViewModel {
        let buttonTitle = String.signOut.localized("signOutButtonTitle")
        return GOVUKButton.ButtonViewModel(
            localisedTitle: buttonTitle,
            action: { [weak self] in
                self?.authenticationService.signOut()
                self?.trackNavigationEvent(buttonTitle)
                self?.completion()
            }
        )
    }

    var cancelButtonViewModel: GOVUKButton.ButtonViewModel {
        let buttonTitle = String.common.localized("cancel")
        return GOVUKButton.ButtonViewModel(
            localisedTitle: buttonTitle,
            action: { [weak self] in
                self?.trackNavigationEvent(buttonTitle)
                self?.completion()
            }
        )
    }

    private func trackNavigationEvent(_ title: String) {
        let event = AppEvent.buttonNavigation(
            text: title,
            external: false
        )
        analyticsService.track(event: event)
    }

    func trackScreen(screen: TrackableScreen) {
        analyticsService.track(screen: screen)
    }
}
