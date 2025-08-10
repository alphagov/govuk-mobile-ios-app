import SwiftUI
import GOVKit
import UIComponents

class ChatInfoOnboardingViewModel: InfoViewModelInterface {
    private let analyticsService: AnalyticsServiceInterface
    private let completionAction: () -> Void
    let cancelOnboardingAction: () -> Void

    init(analyticsService: AnalyticsServiceInterface,
         completionAction: @escaping () -> Void,
         cancelOnboardingAction: @escaping () -> Void) {
        self.analyticsService = analyticsService
        self.completionAction = completionAction
        self.cancelOnboardingAction = cancelOnboardingAction
    }

    var rightBarButtonItem: UIBarButtonItem {
        UIBarButtonItem(
            title: String.common.localized("cancel"),
            style: .plain,
            target: self,
            action: #selector(cancelOnboarding)
        )
    }

    var title: String {
        String.chat.localized("onboardingInfoTitle")
    }

    var subtitle: String {
        String.chat.localized("onboardingInfoDescription")
    }

    var buttonTitle: String {
        String.common.localized("continue")
    }

    var buttonViewModel: GOVUKButton.ButtonViewModel {
        let localTitle = buttonTitle
        return .init(
            localisedTitle: localTitle,
            action: { [weak self] in
                self?.completionAction()
            }
        )
    }

    var image: AnyView {
        AnyView(
            Image(decorative: "chat_onboarding_info")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.bottom, 16)
                .frame(width: 140, height: 130)
        )
    }

    var showImageWhenCompact: Bool {
        true
    }

    var subtitleFont: Font {
        Font.govUK.body
    }

    var navBarHidden: Bool {
        false
    }

    var trackingTitle: String {
        title
    }

    var trackingName: String {
        "First chat onboarding"
    }

    @objc
    func cancelOnboarding() {
        cancelOnboardingAction()
    }
}
