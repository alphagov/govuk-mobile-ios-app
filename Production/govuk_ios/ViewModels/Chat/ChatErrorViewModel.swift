import Foundation
import GOVKit
import UIComponents
import SwiftUI

final class ChatErrorViewModel: InfoViewModelInterface {
    private let action: () -> Void
    private let error: Error

    init(error: Error,
         action: @escaping () -> Void) {
        self.error = error
        self.action = action
    }

    var title: String {
        networkUnavailable ?
        String.common.localized("networkUnavailableErrorTitle") :
        String.common.localized("genericErrorTitle")
    }

    var subtitle: String {
        networkUnavailable ?
        String.common.localized("networkUnavailableErrorBody") :
        String.common.localized("genericErrorBody")
    }

    var buttonTitle: String {
        networkUnavailable ?
        String.common.localized("networkUnavailableButtonTitle") :
        String.common.localized("genericErrorButtonTitle")
    }

    var buttonAccessibilityTitle: String {
        networkUnavailable ?
        String.common.localized("networkUnavailableButtonTitle") :
        String.common.localized("genericErrorButtonTitleAccessibilityLabel")
    }

    var buttonViewModel: GOVUKButton.ButtonViewModel {
        GOVUKButton.ButtonViewModel(
            localisedTitle: buttonTitle,
            action: { [weak self] in
                self?.action()
            }
        )
    }

    var buttonConfiguration: GOVUKButton.ButtonConfiguration {
        if error as? ChatError == .networkUnavailable {
            .primary
        } else {
            .secondary
        }
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

    private var networkUnavailable: Bool {
        error as? ChatError == .networkUnavailable
    }
}
