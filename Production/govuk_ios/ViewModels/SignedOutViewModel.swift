import Foundation
import GOVKit
import UIComponents

final class SignedOutViewModel {
    let title: String = String.signOut.localized("signedOutTitle")
    let subTitle: String = String.signOut.localized("signedOutSubtitle")

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

    var signInButtonViewModel: GOVUKButton.ButtonViewModel {
        let buttonTitle = String.signOut.localized("signInButtonTitle")
        return GOVUKButton.ButtonViewModel(
            localisedTitle: buttonTitle,
            action: { [weak self] in
                self?.authenticationService.signOut()
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
