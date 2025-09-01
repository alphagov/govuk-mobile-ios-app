import Foundation

@testable import GOVKitTestUtilities
@testable import govuk_ios

final class ChatConsentOnboardingViewControllerSnapshotTests: SnapshotTestCase {
    func test_loadInNavigationController_light_rendersCorrectly() {
        let viewModel = ChatConsentOnboardingViewModel(
            analyticsService: MockAnalyticsService(),
            chatService: MockChatService(),
            cancelOnboardingAction: { },
            completionAction: { }
        )
        let chatConsentOnboardingView = ChatConsentOnboardingView(viewModel: viewModel)

        VerifySnapshotInNavigationController(
            view: chatConsentOnboardingView,
            mode: .light
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        let viewModel = ChatConsentOnboardingViewModel(
            analyticsService: MockAnalyticsService(),
            chatService: MockChatService(),
            cancelOnboardingAction: { },
            completionAction: { }
        )
        let chatConsentOnboardingView = ChatConsentOnboardingView(viewModel: viewModel)

        VerifySnapshotInNavigationController(
            view: chatConsentOnboardingView,
            mode: .dark
        )
    }
}

