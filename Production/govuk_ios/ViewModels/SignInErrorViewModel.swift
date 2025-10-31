import Foundation
import GOVKit
import UIComponents
import SwiftUI

final class SignInErrorViewModel: InfoViewModelInterface {
    private let error: AuthenticationError
    private let completion: () -> Void

    init(error: AuthenticationError,
         completion: @escaping () -> Void) {
        self.error = error
        self.completion = completion
    }

    var analyticsService: AnalyticsServiceInterface? { nil }
    var trackingName: String { "" }
    var trackingTitle: String { "" }

    var errorCode: String {
        switch error {
        case .loginFlow(let loginErrorV2):
            return loginErrorV2.govukErrorCode
        case .returningUserService(let returningUserServiceError):
            return returningUserServiceError.govukErrorCode
        case .attestation(let error):
            return error.govukErrorCode
        case .genericError:
            return "1"
        }
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
