import SwiftUI

public struct AppErrorViewModel {
    var title: String?
    var body: String?
    var buttonTitle: String?
    var buttonAccessibilityLabel: String?
    var isWebLink: Bool = false
    var action: (() -> Void)?
    
    public init(title: String? = nil,
                body: String? = nil,
                buttonTitle: String? = nil,
                buttonAccessibilityLabel: String? = nil,
                isWebLink: Bool = false,
                action: ( () -> Void)? = nil) {
        self.title = title
        self.body = body
        self.buttonTitle = buttonTitle
        self.buttonAccessibilityLabel = buttonAccessibilityLabel
        self.isWebLink = isWebLink
        self.action = action
    }

    public static func networkUnavailable(action: @escaping (() -> Void)) -> AppErrorViewModel {
        return .init(
            title: String.common.localized("networkUnavailableErrorTitle"),
            body: String.common.localized("networkUnavailableErrorBody"),
            buttonTitle: String.common.localized("networkUnavailableButtonTitle"),
            action: {
                action()
            }
        )
    }

    public static func genericError(urlOpener: URLOpener) -> AppErrorViewModel {
        return .init(
            title: String.common.localized("genericErrorTitle"),
            body: String.common.localized("genericErrorBody"),
            buttonTitle: String.common.localized("genericErrorButtonTitle"),
            buttonAccessibilityLabel: String.common.localized(
                "genericErrorButtonTitleAccessibilityLabel"
            ),
            isWebLink: true,
            action: {
                urlOpener.openIfPossible(Constants.API.govukBaseUrl)
            }
        )
    }
}
