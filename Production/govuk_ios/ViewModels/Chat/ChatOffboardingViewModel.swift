import SwiftUI
import GOVKit
import UIComponents

class ChatOffboardingViewModel: InfoViewModelInterface {
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
            Image(decorative: "chat_onboarding_info")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 140, height: 140)
                .padding(.bottom, 16)
        )
    }

    var title: String {
        String.chat.localized("offboardingTitle")
    }

    var subtitle: String {
        String.chat.localized("offboardingDescription")
    }

    var primaryButtonTitle: String {
        String.common.localized("continue")
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

    var trackingTitle: String {
        title
    }

    var trackingName: String {
        "Chat offboarding"
    }

    private func trackAction(_ text: String) {
        let event = AppEvent.buttonNavigation(
            text: text,
            external: false
        )
        analyticsService?.track(event: event)
    }
}
