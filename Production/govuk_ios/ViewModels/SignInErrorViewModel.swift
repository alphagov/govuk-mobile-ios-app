import Foundation
import GOVKit
import UIComponents
import SwiftUI

final class SignInErrorViewModel: AuthenticationInfoViewModelInterface {
    let analyticsService: AnalyticsServiceInterface
    private let completion: () -> Void

    init(analyticsService: AnalyticsServiceInterface,
         completion: @escaping () -> Void) {
        self.analyticsService = analyticsService
        self.completion = completion
    }

    var title: String {
        String.signOut.localized("signInErrorTitle")
    }

    var subtitle: String {
        String.signOut.localized("signInErrorSubtitle")
    }

    var buttonTitle: String {
        String.signOut.localized("signInRetryButtonTitle")
    }

    var buttonViewModel: GOVUKButton.ButtonViewModel {
        GOVUKButton.ButtonViewModel(
            localisedTitle: buttonTitle) { [weak self] in
                guard let self = self else { return }
                self.trackNavigationEvent(self.buttonTitle)
                self.completion()
            }
    }

    var image: Image? {
        Image(systemName: "exclamationmark.circle")
    }

    var trackingName: String { "Sign In Error" }
    var trackingTitle: String { title }

    private func trackNavigationEvent(_ title: String) {
        let event = AppEvent.buttonNavigation(
            text: title,
            external: false
        )
        analyticsService.track(event: event)
    }
}
