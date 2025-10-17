import Testing
import UIKit

@testable import govuk_ios

struct ChatInfoOnboardingViewModelTests {
    @Test
    func buttonViewModel_action_callsCompletion() async {
        await confirmation { confirmation in
            let sut = ChatInfoOnboardingViewModel(
                analyticsService: MockAnalyticsService(),
                completionAction: { confirmation() },
                cancelOnboardingAction: { }
            )
            sut.primaryButtonViewModel.action()
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

        #expect(sut.trackingName == "Chat Onboarding Screen One")
    }

    @Test
    func buttonViewModel_action_tracksEvent() {
        let mockAnalyticsService = MockAnalyticsService()
        let sut = ChatInfoOnboardingViewModel(
            analyticsService: mockAnalyticsService,
            completionAction: { },
            cancelOnboardingAction: { }
        )
        sut.primaryButtonViewModel.action()

        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(mockAnalyticsService._trackedEvents.first?.params?["text"] as? String == "Continue")
    }

    @Test
    func cancelOnboarding_callsActionAndTracksEvent() async {
        await confirmation() { confirmation in
            let mockAnalyticsService = MockAnalyticsService()
            let sut = ChatInfoOnboardingViewModel(
                analyticsService: mockAnalyticsService,
                completionAction: { },
                cancelOnboardingAction: { confirmation() }
            )
            sut.cancelOnboarding()

            #expect(mockAnalyticsService._trackedEvents.count == 1)
            #expect(mockAnalyticsService._trackedEvents.first?.params?["text"] as? String == "Cancel")
        }
    }
}
