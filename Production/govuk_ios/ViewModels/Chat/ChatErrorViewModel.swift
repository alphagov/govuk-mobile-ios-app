import Foundation
import GOVKit
import UIComponents
import SwiftUI

final class ChatErrorViewModel: InfoViewModelInterface {
    private let action: () -> Void
    private let error: ChatError
    var analyticsService: AnalyticsServiceInterface?

    init(analyticsService: AnalyticsServiceInterface,
         error: ChatError,
         action: @escaping () -> Void) {
        self.analyticsService = analyticsService
        self.error = error
        self.action = action
    }

    var title: String {
        error  == .networkUnavailable ?
        String.common.localized("networkUnavailableErrorTitle") :
        String.common.localized("genericErrorTitle")
    }

    var subtitle: String {
        switch error {
        case .networkUnavailable:
            String.common.localized("networkUnavailableErrorBody")
        case .pageNotFound:
            String.chat.localized("pageNotFoundErrorBody")
        default:
            String.chat.localized("genericErrorBody")
        }
    }

    var primaryButtonTitle: String {
        switch error {
        case .networkUnavailable:
            String.common.localized("networkUnavailableButtonTitle")
        case .pageNotFound:
            String.chat.localized("pageNotFoundButtonTitle")
        default:
            ""
        }
    }

    var primaryButtonViewModel: GOVUKButton.ButtonViewModel {
        GOVUKButton.ButtonViewModel(
            localisedTitle: primaryButtonTitle,
            action: { [weak self] in
                self?.action()
            }
        )
    }

    var showPrimaryButton: Bool {
        error == .pageNotFound || error == .networkUnavailable
    }

    var image: AnyView {
        AnyView(
            InfoSystemImage(imageName: "exclamationmark.circle")
        )
    }

    var trackingTitle: String {
        title
    }

    var trackingName: String {
        "Chat Error"
    }
}
