import Foundation
import GOVKit
import UIComponents
import SwiftUI

final class SignInSuccessViewModel: InfoViewModelInterface {
    private let completion: () -> Void

    init(completion: @escaping () -> Void) {
        self.completion = completion
    }

    var title: String {
        String.onboarding.localized("successfulSignInTitle")
    }

    var primaryButtonTitle: String {
        String.common.localized("continue")
    }

    var primaryButtonViewModel: GOVUKButton.ButtonViewModel {
        let localTitle = primaryButtonTitle
        return .init(
            localisedTitle: localTitle,
            action: { [weak self] in
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

    var subtitleFont: Font {
        Font.govUK.title1
    }
}
