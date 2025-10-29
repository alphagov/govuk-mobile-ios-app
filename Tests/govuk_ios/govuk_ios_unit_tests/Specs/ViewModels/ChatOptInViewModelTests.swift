import Testing
import UIKit

@testable import govuk_ios

struct ChatOptInViewModelTests {
    @Test
    func primaryButtonViewModel_action_callsCompletion() async {
        await confirmation { confirmation in
            let mockChatService = MockChatService()
            let sut = ChatOptInViewModel(
                analyticsService: MockAnalyticsService(),
                chatService: mockChatService,
                completionAction: { confirmation() }
            )

            #expect(mockChatService.chatOptedIn == nil)
            sut.primaryButtonViewModel.action()
            #expect(mockChatService.chatOptedIn!)
        }
    }

    @Test
    func primaryButtonViewModel_action_tracksEvent() {
        let mockAnalyticsService = MockAnalyticsService()
        let sut = ChatOptInViewModel(
            analyticsService: mockAnalyticsService,
            chatService: MockChatService(),
            completionAction: { }
        )

        sut.primaryButtonViewModel.action()
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(
            mockAnalyticsService._trackedEvents.first?.params?["text"] as? String == "Add GOV.UK Chat to the app"
        )
    }

    @Test
    func secondaryButtonViewModel_action_callsCompletion() async {
        await confirmation { confirmation in
            let mockChatService = MockChatService()
            let sut = ChatOptInViewModel(
                analyticsService: MockAnalyticsService(),
                chatService: mockChatService,
                completionAction: { confirmation() }
            )

            #expect(mockChatService.chatOptedIn == nil)
            sut.secondaryButtonViewModel?.action()
            #expect(!mockChatService.chatOptedIn!)
        }
    }

    @Test
    func secondaryButtonViewModel_action_tracksEvent() {
        let mockAnalyticsService = MockAnalyticsService()
        let sut = ChatOptInViewModel(
            analyticsService: mockAnalyticsService,
            chatService: MockChatService(),
            completionAction: { }
        )

        sut.secondaryButtonViewModel?.action()
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(
            mockAnalyticsService._trackedEvents.first?.params?["text"] as? String == "Do not add GOV.UK Chat"
        )
    }
}
