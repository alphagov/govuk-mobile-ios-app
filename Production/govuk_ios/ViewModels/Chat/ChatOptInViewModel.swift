import SwiftUI
import GOVKit
import UIComponents

class ChatOptInViewModel {
    private var analyticsService: AnalyticsServiceInterface
    private let chatService: ChatServiceInterface
    private let completionAction: () -> Void

    init(analyticsService: AnalyticsServiceInterface,
         chatService: ChatServiceInterface,
         completionAction: @escaping () -> Void) {
        self.analyticsService = analyticsService
        self.chatService = chatService
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
                self?.completionAction()
                self?.trackAction(primaryButtonTitle)
            }
        )
    }

    var secondaryButtonViewModel: GOVUKButton.ButtonViewModel {
        var secondaryButtonTitle = String.chat.localized("optInSecondaryButtonTitle")
        return .init(
            localisedTitle: secondaryButtonTitle,
            action: { [weak self] in
                self?.completionAction()
                self?.trackAction(secondaryButtonTitle)
            }
        )
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
