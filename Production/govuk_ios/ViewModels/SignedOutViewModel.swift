import SwiftUI
import GOVKit
import UIComponents

final class SignedOutViewModel: AuthenticationInfoViewModelInterface {
    let analyticsService: AnalyticsServiceInterface
    private let authenticationService: AuthenticationServiceInterface
    private let completion: () -> Void

    init(authenticationService: AuthenticationServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         completion: @escaping () -> Void) {
        self.authenticationService = authenticationService
        self.analyticsService = analyticsService
        self.completion = completion
    }

    var title: String {
        authenticationService.isSignedIn ?
        String.signOut.localized("signedOutErrorTitle") :
        String.signOut.localized("signedOutTitle")
    }

    var subtitle: String {
        authenticationService.isSignedIn ?
        String.signOut.localized("signedOutErrorSubtitle") :
        String.signOut.localized("signedOutSubtitle")
    }

    var buttonTitle: String {
        authenticationService.isSignedIn ?
        String.signOut.localized("signedOutErrorButtonTitle") :
        String.signOut.localized("signedOutButtonTitle")
    }

    var image: Image? {
        authenticationService.isSignedIn ?
        Image(systemName: "exclamationmark.circle") :
        nil
    }

    var buttonViewModel: GOVUKButton.ButtonViewModel {
        return GOVUKButton.ButtonViewModel(
            localisedTitle: buttonTitle,
            action: { [weak self] in
                guard let self = self else { return }
                self.trackNavigationEvent(self.buttonTitle)
                self.completion()
            }
        )
    }

    var trackingName: String {
        "Signed Out"
    }

    var trackingTitle: String {
        title
    }

    private func trackNavigationEvent(_ title: String) {
        let event = AppEvent.buttonNavigation(
            text: title,
            external: false
        )
        analyticsService.track(event: event)
    }
}
