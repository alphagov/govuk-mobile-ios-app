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

    @Test
    func trackingTitle_returnsTitle() {
        let sut = ChatInfoOnboardingViewModel(
            analyticsService: MockAnalyticsService(),
            completionAction: { },
            cancelOnboardingAction: { }
        )

        #expect(sut.trackingTitle == "Get quick answers from GOV.UK Chat")
    }

    @Test
    func trackingName_returnsCorrectValue() {
        let sut = ChatInfoOnboardingViewModel(
            analyticsService: MockAnalyticsService(),
            completionAction: { },
            cancelOnboardingAction: { }
        )

        #expect(sut.trackingName == "First chat onboarding")
    }
}
