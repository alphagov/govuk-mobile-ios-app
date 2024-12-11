import SwiftUI

struct AppErrorViewModel {
    var title: String?
    var body: String?
    var buttonTitle: String?
    var buttonAccessibilityLabel: String?
    var isWebLink: Bool = false
    var action: (() -> Void)?

    static func networkUnavailable(action: @escaping (() -> Void)) -> AppErrorViewModel {
        return .init(
            title: String.common.localized("networkUnavailableErrorTitle"),
            body: String.common.localized("networkUnavailableErrorBody"),
            buttonTitle: String.common.localized("networkUnavailableButtonTitle"),
            action: {
                action()
            }
        )
    }

    static func genericError(urlOpener: URLOpener) -> AppErrorViewModel {
        return .init(
            title: String.common.localized("genericErrorTitle"),
            body: String.common.localized("genericErrorBody"),
            buttonTitle: String.common.localized("genericErrorButtonTitle"),
            buttonAccessibilityLabel: String.common.localized(
                "genericErrorTitleAccessibilityLabel"
            ),
            isWebLink: true,
            action: {
                urlOpener.openIfPossible(Constants.API.govukBaseUrl)
            }
        )
    }
}
