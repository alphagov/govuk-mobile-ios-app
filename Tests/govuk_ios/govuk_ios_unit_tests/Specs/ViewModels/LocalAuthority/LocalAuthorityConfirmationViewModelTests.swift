import Testing

@testable import GOVKitTestUtilities
@testable import govuk_ios

@Suite
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
            dismiss: {}
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
        var dismiss = false
        let sut = LocalAuthorityConfirmationViewModel(
            analyticsService: mockAnalyticsService,
            localAuthorityItem: authority,
            dismiss: {
                dismiss = true
            }
        )
        sut.primaryButtonViewModel.action()
        #expect(dismiss)
    }

}
