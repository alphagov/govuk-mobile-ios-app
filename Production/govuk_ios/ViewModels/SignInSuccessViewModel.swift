import Foundation
import GOVKit
import UIComponents
import SwiftUI

final class SignInSuccessViewModel: InfoViewModelInterface {
    let analyticsService: AnalyticsServiceInterface
    private let completion: () -> Void

    init(analyticsService: AnalyticsServiceInterface,
         completion: @escaping () -> Void) {
        self.analyticsService = analyticsService
        self.completion = completion
    }

    var title: String {
        String.onboarding.localized("successfulSignInTitle")
    }

    var subtitle: String {
        ""
    }

    var buttonTitle: String {
        String.common.localized("continue")
    }

    var buttonViewModel: GOVUKButton.ButtonViewModel {
        let localTitle = buttonTitle
        return .init(
            localisedTitle: localTitle,
            action: { [weak self] in
                self?.trackNavigationEvent(localTitle)
                self?.completion()
            }
        )
    }

    var image: AnyView {
        AnyView(
            Image(decorative: "sign_in_success")
                .padding(.bottom, 16)
        )
    }

    var showImageWhenCompact: Bool {
        false
    }

    var subtitleFont: Font {
        Font.govUK.title1
    }

    var trackingName: String { "Sign in success" }

    var trackingTitle: String { title }

    private func trackNavigationEvent(_ title: String) {
        let event = AppEvent.buttonNavigation(
            text: title,
            external: false
        )
        analyticsService.track(event: event)
    }
}
