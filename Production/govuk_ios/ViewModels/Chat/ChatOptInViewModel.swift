import SwiftUI
import GOVKit
import UIComponents

class ChatOptInViewModel: InfoViewModelInterface {
    var analyticsService: AnalyticsServiceInterface?
    private var chatService: ChatServiceInterface
    private let completionAction: () -> Void

    init(analyticsService: AnalyticsServiceInterface,
         chatService: ChatServiceInterface,
         completionAction: @escaping () -> Void) {
        self.analyticsService = analyticsService
        self.chatService = chatService
        self.completionAction = completionAction
    }

    var image: AnyView {
        AnyView(
            Image.chatOnboardingImage
        )
    }

    var title: String {
        String.chat.localized("optInTitle")
    }

    var subtitle: String {
        String.chat.localized("optInDescription")
    }

    var primaryButtonTitle: String {
        String.chat.localized("optInPrimaryButtonTitle")
    }

    var secondaryButtonTitle: String {
        String.chat.localized("optInSecondaryButtonTitle")
    }

    var primaryButtonViewModel: GOVUKButton.ButtonViewModel {
        return .init(
            localisedTitle: primaryButtonTitle,
            action: { [weak self] in
                guard let self else { return }
                chatService.chatOptedIn = true
                trackAction(primaryButtonTitle)
                completionAction()
            }
        )
    }

    var secondaryButtonViewModel: GOVUKButton.ButtonViewModel? {
        return .init(
            localisedTitle: secondaryButtonTitle,
            action: { [weak self] in
                guard let self else { return }
                chatService.chatOptedIn = false
                trackAction(secondaryButtonTitle)
                completionAction()
            }
        )
    }

    var trackingTitle: String {
        title
    }

    var trackingName: String {
        "Chat opt-in"
    }

    private func trackAction(_ text: String) {
        let event = AppEvent.buttonNavigation(
            text: text,
            external: false
        )
        analyticsService?.track(event: event)
    }
}
