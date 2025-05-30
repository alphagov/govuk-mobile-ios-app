import Foundation
import GOVKit
import UIComponents
import SwiftUI

final class WelcomeOnboardingViewModel: InfoViewModelInterface {
    let analyticsService: AnalyticsServiceInterface
    private let completeAction: () -> Void

    init(analyticsService: AnalyticsServiceInterface,
         completeAction: @escaping () -> Void) {
        self.analyticsService = analyticsService
        self.completeAction = completeAction
    }

    var title: String {
        String.onboarding.localized("welcomeTitle")
    }

    var subtitle: String {
        String.onboarding.localized("welcomeBody")
    }

    var buttonTitle: String {
        String.signOut.localized("signInRetryButtonTitle")
    }

    var buttonViewModel: GOVUKButton.ButtonViewModel {
        let localTitle = String.onboarding.localized("welcomeButtonTitle")
        return .init(
            localisedTitle: localTitle,
            action: { [weak self] in
                self?.trackNavigationEvent(localTitle)
                self?.completeAction()
            }
        )
    }

    var image: AnyView {
        AnyView(
            Image(decorative: "onboarding_welcome")
                .padding(.bottom, 16)
        )
    }

    var showImageWhenCompact: Bool {
        false
    }

    var subtitleFont: Font {
        Font.govUK.title1
    }

    var trackingName: String { "Welcome onboarding" }

    var trackingTitle: String { title }

    private func trackNavigationEvent(_ title: String) {
        let event = AppEvent.buttonNavigation(
            text: title,
            external: false
        )
        analyticsService.track(event: event)
    }
}
