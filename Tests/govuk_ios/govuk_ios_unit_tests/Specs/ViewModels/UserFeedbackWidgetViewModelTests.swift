import Foundation
import Testing

@testable import govuk_ios

@Suite
struct UserFeedbackWidgetViewModelTests {
    @Test
    func open_tracks_navigationEvent() throws {
        let mockAnalyticsService = MockAnalyticsService()
        let link = UserFeedbackBanner.Link(title: "Title", url: URL(string: "https://www.test.com")!)
        let userFeedback = UserFeedbackBanner(body: "Body", link: link)
        let sut = UserFeedbackWidgetViewModel(
            userFeedback: userFeedback,
            analyticsService: mockAnalyticsService,
            urlOpener: MockURLOpener()
        )
        sut.open()

        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(mockAnalyticsService._trackedEvents.first?.params?["text"] as? String == "Title")
        #expect(mockAnalyticsService._trackedEvents.first?.params?["type"] as? String == "Widget")
        #expect(mockAnalyticsService._trackedEvents.first?.params?["external"] as? Bool == true)
        #expect(mockAnalyticsService._trackedEvents.first?.params?["section"] as? String == "Homepage")
        #expect(mockAnalyticsService._trackedEvents.first?.params?["url"] as? String == "https://www.test.com")
    }

    @Test
    func open_receivesExpectedUrl() throws {
        let link = UserFeedbackBanner.Link(title: "Title", url: URL(string: "https://www.test.com")!)
        let userFeedback = UserFeedbackBanner(body: "Body", link: link)
        let mockUrlOpener = MockURLOpener()
        let sut = UserFeedbackWidgetViewModel(
            userFeedback: userFeedback,
            analyticsService: MockAnalyticsService(),
            urlOpener: mockUrlOpener
        )
        sut.open()

        #expect(mockUrlOpener._receivedOpenIfPossibleUrl == URL(string: "https://www.test.com")!)
    }
}
