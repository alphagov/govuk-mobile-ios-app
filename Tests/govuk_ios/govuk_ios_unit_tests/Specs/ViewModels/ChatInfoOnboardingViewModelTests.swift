import Testing
import UIKit

@testable import govuk_ios
@testable import GOVKitTestUtilities

struct ChatInfoOnboardingViewModelTests {
    @Test
    func buttonViewModel_action_callsCompletion() async {
        await confirmation { confirmation in
            let sut = ChatInfoOnboardingViewModel(
                analyticsService: MockAnalyticsService(),
                completionAction: { confirmation() },
                cancelOnboardingAction: { }
            )
            sut.buttonViewModel.action()
        }
    }

    @Test
    func rightBarButtonItem_returnsBarButton() {
        let sut = ChatInfoOnboardingViewModel(
            analyticsService: MockAnalyticsService(),
            completionAction: { },
            cancelOnboardingAction: { }
        )

        #expect((sut.rightBarButtonItem as Any) is UIBarButtonItem)
    }
}
