import Foundation
import GOVKit
import UIComponents
import SwiftUI

final class WelcomeOnboardingViewModel: InfoViewModelInterface,
                                        ProgressIndicating {
    private let completeAction: () -> Void

    @Published var showProgressView: Bool = false

    init(completeAction: @escaping () -> Void) {
        self.completeAction = completeAction
    }

    var analyticsService: AnalyticsServiceInterface? { nil }
    var trackingName: String { "" }
    var trackingTitle: String { "" }

    var title: String {
        String.onboarding.localized("welcomeTitle")
    }

    var subtitle: String {
        String.onboarding.localized("welcomeBody")
    }

    var primaryButtonTitle: String {
        String.signOut.localized("signInRetryButtonTitle")
    }

    var primaryButtonViewModel: GOVUKButton.ButtonViewModel {
        let localTitle = String.common.localized("continue")
        return .init(
            localisedTitle: localTitle,
            action: { [weak self] in
                self?.showProgressView = true
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

    var subtitleFont: Font {
        Font.govUK.title1
    }

    var bottomContentText: String? {
        guard let versionNumber = Bundle.main.versionNumber
        else { return "" }
        return "\(String.onboarding.localized("appVersionText")) \(versionNumber)"
    }

    var animationDelay: TimeInterval {
        showProgressView ? 1.0 : 0.0
    }
}
