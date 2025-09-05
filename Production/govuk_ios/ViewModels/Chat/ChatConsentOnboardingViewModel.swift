import SwiftUI
import GOVKit
import UIComponents

class ChatConsentOnboardingViewModel {
    private let analyticsService: AnalyticsServiceInterface
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

    var buttonViewModel: GOVUKButton.ButtonViewModel {
        return .init(
            localisedTitle: buttonTitle,
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

    private var buttonTitle: String {
        return String.chat.localized("onboardingConsentButtonTitle")
    }

    @objc
    func cancelOnboarding() {
        cancelOnboardingAction()
        trackCancelAction()
    }

    func trackScreen(screen: TrackableScreen) {
        analyticsService.track(screen: screen)
    }

    private func trackCancelAction() {
        let event = AppEvent.buttonNavigation(
            text: String.common.localized("cancel"),
            external: false
        )
        analyticsService.track(event: event)
    }

    private func trackCompletionAction() {
        let event = AppEvent.buttonNavigation(
            text: buttonTitle,
            external: false
        )
        analyticsService.track(event: event)
    }
}
