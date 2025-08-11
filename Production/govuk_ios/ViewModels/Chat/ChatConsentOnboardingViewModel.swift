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
            localisedTitle: String.chat.localized("onboardingConsentButtonTitle"),
            action: { [weak self] in
                self?.chatService.setChatOnboarded()
                self?.completionAction()
            }
        )
    }

    var rightBarButtonItem: UIBarButtonItem {
        let barButton = UIBarButtonItem(
            title: String.common.localized("cancel"),
            style: .plain,
            target: self,
            action: #selector(cancelOnboarding)
        )
        barButton.tintColor = .govUK.text.link
        return barButton
    }

    @objc
    func cancelOnboarding() {
        cancelOnboardingAction()
    }
}
