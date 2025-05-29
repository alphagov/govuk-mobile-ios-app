import Foundation
import Testing

@testable import govuk_ios

struct WelcomeOnboardingViewModelTests {
    @Test
    func primaryButtonViewModel_action_completesAction() async {
        let mockAnalyticsService = MockAnalyticsService()
        let completion = await withCheckedContinuation { continuation in
            let sut = WelcomeOnboardingViewModel(
                analyticsService: mockAnalyticsService,
                completeAction: { continuation.resume(returning: true) }
            )
            let buttonViewModel = sut.buttonViewModel
            buttonViewModel.action()
        }

        #expect(completion)
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        let event = mockAnalyticsService._trackedEvents.first
        #expect(event?.params?["text"] as? String == "Get started")
    }
}
