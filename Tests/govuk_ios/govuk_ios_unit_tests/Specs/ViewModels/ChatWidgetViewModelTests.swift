import Foundation
import Testing

@testable import govuk_ios

@Suite
struct ChatWidgetViewModelTests {
    @Test
    func open_receivesExpectedUrl() throws {
        let link = ChatBanner.Link(title: "Title", url: URL(string: "https://www.test.com")!)
        let chat = ChatBanner(id: "1234", title: "Title", body: "Body", link: link)
        let mockUrlOpener = MockURLOpener()
        let sut = ChatWidgetViewModel(
            analyticsService: MockAnalyticsService(),
            chat: chat,
            urlOpener: mockUrlOpener,
            dismiss: {}
        )
        sut.open()

        #expect(mockUrlOpener._receivedOpenIfPossibleUrl == URL(string: "https://www.test.com")!)
    }

    @Test
    func open_tracksEvent() {
        let link = ChatBanner.Link(title: "Title", url: URL(string: "https://www.test.com")!)
        let chat = ChatBanner(id: "1234", title: "Chat widget title", body: "Body", link: link)
        let analyticsService = MockAnalyticsService()
        let sut = ChatWidgetViewModel(
            analyticsService: analyticsService,
            chat: chat,
            urlOpener: MockURLOpener(),
            dismiss: {}
        )
        sut.open()

        #expect(analyticsService._trackedEvents.count == 1)
        #expect(analyticsService._trackedEvents[0].name == "Navigation")
        #expect(analyticsService._trackedEvents[0].params?["text"] as? String == "Chat widget title")
    }
}
