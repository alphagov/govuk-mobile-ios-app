import Testing
import UIKit

@testable import govuk_ios
@testable import GOVKitTestUtilities

struct ChatConsentOnboardingViewModelTests {
    @Test
    func buttonViewModel_action_callsCompletion() async {
        await confirmation { confirmation in
            let mockChatService = MockChatService()
            let sut = ChatConsentOnboardingViewModel(
                analyticsService: MockAnalyticsService(),
                chatService: mockChatService,
                cancelOnboardingAction: { },
                completionAction: { confirmation() }
            )

            #expect(!mockChatService.chatOnboardingSeen)
            sut.buttonViewModel.action()
            #expect(mockChatService.chatOnboardingSeen)
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
