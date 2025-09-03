import Foundation
import GOVKit
import UIComponents
import SwiftUI

final class WelcomeOnboardingViewModel: ObservableObject {
    private let completeAction: () -> Void
    @Published var versionNumber: String?

    init(completeAction: @escaping () -> Void) {
        self.completeAction = completeAction
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

    var image: AnyView {
        AnyView(
            Image(decorative: "onboarding_welcome")
                .padding(.bottom, 16)
        )
    }

    var subtitleFont: Font {
        Font.govUK.title1
    }

    private func getVersionNumber() {
        guard let versionNumber = Bundle.main.versionNumber
        else { return }
        self.versionNumber = "\(String.onboarding.localized("appVersionText")) \(versionNumber)"
    }
}
