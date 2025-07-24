import Foundation
import GOVKit
import UIComponents
import SwiftUI

final class WelcomeOnboardingViewModel: InfoViewModelInterface {
    private let completeAction: () -> Void

    init(completeAction: @escaping () -> Void) {
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
        let localTitle = String.common.localized("continue")
        return .init(
            localisedTitle: localTitle,
            action: { [weak self] in
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
}
