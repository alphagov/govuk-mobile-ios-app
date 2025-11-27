import GOVKit

extension AppErrorViewModel {
    static func topicErrorWithAction(
        _ action: @escaping () -> Void
    ) -> AppErrorViewModel {
        AppErrorViewModel(
            title: String.common.localized("genericErrorTitle"),
            body: String.topics.localized("topicFetchErrorSubtitle"),
            buttonTitle: String.common.localized("genericErrorButtonTitle"),
            buttonAccessibilityLabel: String.common.localized(
                "genericErrorButtonTitleAccessibilityLabel"
            ),
            isWebLink: true,
            action: action
        )
    }
}
