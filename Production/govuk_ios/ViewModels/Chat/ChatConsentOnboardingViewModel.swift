import SwiftUI
import GOVKit
import UIComponents

class ChatConsentOnboardingViewModel: InfoViewModelInterface {
    var analyticsService: AnalyticsServiceInterface?
    private let chatService: ChatServiceInterface
    private let cancelOnboardingAction: () -> Void
    private let completionAction: () -> Void

    init(analyticsService: AnalyticsServiceInterface,
         chatService: ChatServiceInterface,
         cancelOnboardingAction: @escaping () -> Void,
         completionAction: @escaping () -> Void) {
        self.analyticsService = analyticsService
        self.chatService = chatService
        self.cancelOnboardingAction = cancelOnboardingAction
        self.completionAction = completionAction
    }

    var image: AnyView {
        AnyView(
            Image(decorative: "chat_onboarding_consent")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.bottom, 16)
                .frame(width: 120, height: 120)
        )
    }

    var title: String {
        String.chat.localized("onboardingConsentTitle")
    }

    var primaryButtonViewModel: GOVUKButton.ButtonViewModel {
        return .init(
            localisedTitle: primaryButtonTitle,
            action: { [weak self] in
                self?.chatService.setChatOnboarded()
                self?.completionAction()
                self?.trackCompletionAction()
            }
        )
    }

    var rightBarButtonItem: UIBarButtonItem {
        .cancel(target: self, action: #selector(cancelOnboarding))
    }

    var primaryButtonTitle: String {
        return String.chat.localized("onboardingConsentButtonTitle")
    }

    @objc
    func cancelOnboarding() {
        cancelOnboardingAction()
        trackCancelAction()
    }

    private func trackCancelAction() {
        let event = AppEvent.buttonNavigation(
            text: String.common.localized("cancel"),
            external: false
        )
        analyticsService?.track(event: event)
    }

    private func trackCompletionAction() {
        let event = AppEvent.buttonNavigation(
            text: primaryButtonTitle,
            external: false
        )
        analyticsService?.track(event: event)
    }
}
