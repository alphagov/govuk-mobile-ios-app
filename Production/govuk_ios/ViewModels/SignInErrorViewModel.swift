import Foundation
import GOVKit
import UIComponents
import SwiftUI

final class SignInErrorViewModel: InfoViewModelInterface {
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

    var image: AnyView {
        AnyView(
            InfoSystemImage(imageName: "exclamationmark.circle")
        )
    }

    var showImageWhenCompact: Bool {
        false
    }

    var subtitleFont: Font {
        Font.govUK.body
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
