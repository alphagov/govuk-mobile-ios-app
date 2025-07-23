import Foundation
import GOVKit
import UIComponents
import SwiftUI

final class ChatErrorViewModel: InfoViewModelInterface {
    private let action: () -> Void
    private let error: ChatError
    var openURLAction: ((URL) -> Void)?

    init(error: ChatError,
         action: @escaping () -> Void,
         openURLAction: ((URL) -> Void)?) {
        self.error = error
        self.action = action
        self.openURLAction = openURLAction
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

    var buttonTitle: String {
        switch error {
        case .networkUnavailable:
            String.common.localized("networkUnavailableButtonTitle")
        case .pageNotFound:
            String.chat.localized("pageNotFoundButtonTitle")
        default:
            ""
        }
    }

    var buttonViewModel: GOVUKButton.ButtonViewModel {
        GOVUKButton.ButtonViewModel(
            localisedTitle: buttonTitle,
            action: { [weak self] in
                self?.action()
            }
        )
    }

    var showActionButton: Bool {
        error == .pageNotFound || error == .networkUnavailable
    }

    var showDivider: Bool {
        false
    }

    var image: AnyView {
        AnyView(
            InfoSystemImage(imageName: "exclamationmark.circle")
        )
    }

    var showImageWhenCompact: Bool {
        false
    }

    var subtitleFont: Font {
        Font.govUK.body
    }
}
