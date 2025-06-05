import Testing

@testable import govuk_ios
struct LocalAuthorityConfirmationViewModelTests {

    @Test
    func primaryButtonViewModel_action_trackNavigationEvent() async throws {
        let mockAnalyticsService = MockAnalyticsService()
        let authority = Authority(
            name: "Test",
            homepageUrl: "Test",
            tier: "unitary",
            slug: "test slug",
            parent: nil
        )
        let sut = LocalAuthorityConfirmationViewModel(
            analyticsService: mockAnalyticsService,
            localAuthorityItem: authority,
            completion: {}
        )
        sut.primaryButtonViewModel.action()
        let receivedTitle = mockAnalyticsService._trackedEvents.first?.params?["text"] as? String
        #expect(receivedTitle == "Done")
    }

    @Test
    func primaryButtonViewModel_dismissesView() {
        let mockAnalyticsService = MockAnalyticsService()
        let authority = Authority(
            name: "Test",
            homepageUrl: "Test",
            tier: "unitary",
            slug: "test slug",
            parent: nil
        )
        var completed = false
        let sut = LocalAuthorityConfirmationViewModel(
            analyticsService: mockAnalyticsService,
            localAuthorityItem: authority,
            completion: {
                completed = true
            }
        )
        sut.primaryButtonViewModel.action()
        #expect(completed)
    }

}
