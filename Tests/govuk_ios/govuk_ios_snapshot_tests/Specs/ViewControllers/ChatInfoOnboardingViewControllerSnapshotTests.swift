import Foundation

@testable import govuk_ios

final class ChatInfoOnboardingViewControllerSnapshotTests: SnapshotTestCase {
    func test_loadInNavigationController_light_rendersCorrectly() {
        let viewModel = ChatInfoOnboardingViewModel(
            analyticsService: MockAnalyticsService(),
            completionAction: { },
            cancelOnboardingAction: { }
        )
        let chatInfoOnboardingView = InfoView(viewModel: viewModel)

        VerifySnapshotInNavigationController(
            view: chatInfoOnboardingView,
            mode: .light
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        let viewModel = ChatInfoOnboardingViewModel(
            analyticsService: MockAnalyticsService(),
            completionAction: { },
            cancelOnboardingAction: { }
        )
        let chatInfoOnboardingView = InfoView(viewModel: viewModel)

        VerifySnapshotInNavigationController(
            view: chatInfoOnboardingView,
            mode: .dark
        )
    }
}


