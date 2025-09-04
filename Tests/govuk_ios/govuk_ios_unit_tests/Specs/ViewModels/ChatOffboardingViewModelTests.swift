import Testing
import UIKit

@testable import govuk_ios
@testable import GOVKitTestUtilities

struct ChatOffboardingViewModelTests {
    @Test
    func primaryButtonViewModel_action_callsCompletion() async {
        await confirmation { confirmation in
            let mockChatService = MockChatService()
            let sut = ChatOffboardingViewModel(
                analyticsService: MockAnalyticsService(),
                chatService: mockChatService,
                completionAction: { confirmation() }
            )

            sut.primaryButtonViewModel.action()
        }
    }

    @Test
    func primaryButtonViewModel_action_tracksEvent() {
        let mockAnalyticsService = MockAnalyticsService()
        let sut = ChatOffboardingViewModel(
            analyticsService: mockAnalyticsService,
            chatService: MockChatService(),
            completionAction: { }
        )

        sut.primaryButtonViewModel.action()
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(
            mockAnalyticsService._trackedEvents.first?.params?["text"] as? String == "Continue"
        )
    }
}
