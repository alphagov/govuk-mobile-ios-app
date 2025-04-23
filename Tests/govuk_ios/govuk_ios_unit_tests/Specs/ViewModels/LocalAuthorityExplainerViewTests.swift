import Testing

@testable import govuk_ios

@Suite
struct LocalAuthorityExplainerViewTests {

    @Test
    func explainerViewPrimaryButtonViewModel_action_trackNavigationEvent() async throws {
        let mockAnalyticsService = MockAnalyticsService()
        let sut = LocalAuthorityExplainerViewModel(
            analyticsService: mockAnalyticsService,
            navigateToPosteCodeEntry: {},
            dismissAction: {}
        )
        sut.primaryButtonViewModel.action()
        let receivedTitle = mockAnalyticsService._trackedEvents.first?.params?["text"] as? String
        #expect(receivedTitle == "Continue")
    }
}
