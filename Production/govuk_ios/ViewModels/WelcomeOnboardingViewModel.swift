import Foundation
import GOVKit
import UIComponents
import SwiftUI

final class WelcomeOnboardingViewModel: ObservableObject {
    let analyticsService: AnalyticsServiceInterface
    private let completeAction: () -> Void
    @Published var versionNumber: String?

    init(analyticsService: AnalyticsServiceInterface,
         completeAction: @escaping () -> Void) {
        self.completeAction = completeAction
        self.analyticsService = analyticsService
        getVersionNumber()
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
        let localTitle = String.common.localized("continue")
        return .init(
            localisedTitle: localTitle,
            action: { [weak self] in
                self?.completeAction()
            }
        )
    }

    func trackScreen(screen: TrackableScreen) {
        analyticsService.track(screen: screen)
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

    private func getVersionNumber() {
        guard let versionNumber = Bundle.main.versionNumber
        else { return }
        self.versionNumber = "\(String.onboarding.localized("appVersionText")) \(versionNumber)"
    }
}
