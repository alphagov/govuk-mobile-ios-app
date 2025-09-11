import Testing
import UIKit

@testable import govuk_ios
@testable import GOVKitTestUtilities

struct ChatConsentOnboardingViewModelTests {
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
            sut.primaryButtonViewModel.action()
            #expect(mockChatService.chatOnboardingSeen)
        }
    }

    @Test
    func buttonViewModel_action_tracksEvent() {
        let mockAnalyticsService = MockAnalyticsService()
        let sut = ChatConsentOnboardingViewModel(
            analyticsService: mockAnalyticsService,
            chatService: MockChatService(),
            cancelOnboardingAction: { },
            completionAction: { }
        )

        sut.primaryButtonViewModel.action()

        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(mockAnalyticsService._trackedEvents.first?.params?["text"] as? String == "I understand")
    }

    @Test
    func cancelOnboarding_callsActionAndTracksEvent() async {
        await confirmation() { confirmation in
            let mockAnalyticsService = MockAnalyticsService()
            let sut = ChatConsentOnboardingViewModel(
                analyticsService: mockAnalyticsService,
                chatService: MockChatService(),
                cancelOnboardingAction: { confirmation() },
                completionAction: { }
            )

            sut.cancelOnboarding()
            #expect(mockAnalyticsService._trackedEvents.count == 1)
            #expect(mockAnalyticsService._trackedEvents.first?.params?["text"] as? String == "Cancel")
        }
    }
}
