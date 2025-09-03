import Foundation
import GOVKit
import UIComponents
import SwiftUI

final class SignInErrorViewModel: InfoViewModelInterface {
    private let completion: () -> Void

    init(completion: @escaping () -> Void) {
        self.completion = completion
    }

    var title: String {
        String.signOut.localized("signInErrorTitle")
    }

    var subtitle: String {
        String.signOut.localized("signInErrorSubtitle")
    }

    var primaryButtonTitle: String {
        String.signOut.localized("signInRetryButtonTitle")
    }

    var primaryButtonViewModel: GOVUKButton.ButtonViewModel {
        GOVUKButton.ButtonViewModel(
            localisedTitle: primaryButtonTitle) { [weak self] in
                guard let self = self else { return }
                self.completion()
            }
    }

    var image: AnyView {
        AnyView(
            InfoSystemImage(imageName: "exclamationmark.circle")
        )
    }
}
