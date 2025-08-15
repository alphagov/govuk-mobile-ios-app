import SwiftUI
import GOVKit
import UIComponents

class ChatInfoOnboardingViewModel: InfoViewModelInterface {
    private let analyticsService: AnalyticsServiceInterface
    private let completionAction: () -> Void
    private let cancelOnboardingAction: () -> Void

    init(analyticsService: AnalyticsServiceInterface,
         completionAction: @escaping () -> Void,
         cancelOnboardingAction: @escaping () -> Void) {
        self.analyticsService = analyticsService
        self.completionAction = completionAction
        self.cancelOnboardingAction = cancelOnboardingAction
    }

    var rightBarButtonItem: UIBarButtonItem {
        .cancel(target: self, action: #selector(cancelOnboarding))
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
                .frame(width: 150, height: 150)
        )
    }

    var showImageWhenCompact: Bool {
        false
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
