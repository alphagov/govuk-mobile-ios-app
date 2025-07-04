import SwiftUI
import GOVKit
import UIComponents

final class SignedOutViewModel: InfoViewModelInterface {
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

    var image: AnyView {
        if authenticationService.isSignedIn {
            AnyView(
                InfoSystemImage(imageName: "exclamationmark.circle")
            )
        } else {
            AnyView(
                EmptyView()
            )
        }
    }

    var buttonViewModel: GOVUKButton.ButtonViewModel {
        GOVUKButton.ButtonViewModel(
            localisedTitle: buttonTitle,
            action: { [weak self] in
                guard let self = self else { return }
                self.trackNavigationEvent(self.buttonTitle)
                self.completion()
            }
        )
    }

    var showImageWhenCompact: Bool {
        false
    }

    var subtitleFont: Font {
        Font.govUK.body
    }

    var trackingName: String { "Signed Out" }
    var trackingTitle: String { title }

    private func trackNavigationEvent(_ title: String) {
        let event = AppEvent.buttonNavigation(
            text: title,
            external: false
        )
        analyticsService.track(event: event)
    }
}
