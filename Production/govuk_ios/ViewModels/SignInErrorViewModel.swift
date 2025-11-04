import Foundation
import GOVKit
import UIComponents
import SwiftUI

final class SignInErrorViewModel: InfoViewModelInterface {
    private let error: AuthenticationError
    private let feedbackAction: (AuthenticationError) -> Void
    private let retryAction: () -> Void

    init(error: AuthenticationError,
         feedbackAction: @escaping (AuthenticationError) -> Void,
         retryAction: @escaping () -> Void) {
        self.error = error
        self.feedbackAction = feedbackAction
        self.retryAction = retryAction
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
        case .unknown:
            return "1"
        }
    }

    var title: String {
        String.signOut.localized("signInErrorTitle")
    }

    var subtitle: String {
        switch error {
        case .unknown:
            return String.signOut.localized("signInErrorUnknownSubtitle")
        default:
            return String.signOut.localized("signInErrorSubtitle")
        }
    }

    var primaryButtonTitle: String {
        switch error {
        case .unknown:
            return String.signOut.localized("signInReportButtonTitle")
        default:
            return String.signOut.localized("signInRetryButtonTitle")
        }
    }

    var primaryButtonViewModel: GOVUKButton.ButtonViewModel {
        GOVUKButton.ButtonViewModel(
            localisedTitle: primaryButtonTitle,
            action: { [weak self] in
                self?.primaryButtonAction()
            }
        )
    }

    var secondaryButtonViewModel: GOVUKButton.ButtonViewModel? {
        guard case .unknown = error
        else { return nil }
        return GOVUKButton.ButtonViewModel(
            localisedTitle: String.signOut.localized("signInSecondaryButtonTitle"),
            action: { [weak self] in
                self?.retryAction()
            }
        )
    }

    private func primaryButtonAction() {
        if case .unknown = error {
            feedbackAction(error)
        } else {
            retryAction()
        }
    }

    var image: AnyView {
        AnyView(
            InfoSystemImage(imageName: "exclamationmark.circle")
        )
    }
}
