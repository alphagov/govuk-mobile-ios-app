import SwiftUI
import GOVKit
import UIComponents

class ChatOptInViewModel {
    private let analyticsService: AnalyticsServiceInterface
    private var chatService: ChatServiceInterface
    private let completionAction: () -> Void

    let openURLAction: (URL) -> Void

    init(analyticsService: AnalyticsServiceInterface,
         chatService: ChatServiceInterface,
         openURLAction: @escaping (URL) -> Void,
         completionAction: @escaping () -> Void) {
        self.analyticsService = analyticsService
        self.chatService = chatService
        self.openURLAction = openURLAction
        self.completionAction = completionAction
    }

    var title: String {
        String.chat.localized("optInTitle")
    }

    var primaryButtonViewModel: GOVUKButton.ButtonViewModel {
        let primaryButtonTitle = String.chat.localized("optInPrimaryButtonTitle")
        return .init(
            localisedTitle: primaryButtonTitle,
            action: { [weak self] in
                self?.chatService.chatOptedIn = true
                self?.trackAction(primaryButtonTitle)
                self?.completionAction()
            }
        )
    }

    var secondaryButtonViewModel: GOVUKButton.ButtonViewModel {
        let secondaryButtonTitle = String.chat.localized("optInSecondaryButtonTitle")
        return .init(
            localisedTitle: secondaryButtonTitle,
            action: { [weak self] in
                self?.chatService.chatOptedIn = false
                self?.trackAction(secondaryButtonTitle)
                self?.completionAction()
            }
        )
    }

    var privacyPolicyUrl: URL {
        chatService.privacyPolicy
    }

    var termsURL: URL {
        chatService.termsAndConditions
    }

    func trackScreen(screen: TrackableScreen) {
        analyticsService.track(screen: screen)
    }

    private func trackAction(_ text: String) {
        let event = AppEvent.buttonNavigation(
            text: text,
            external: false
        )
        analyticsService.track(event: event)
    }
}
