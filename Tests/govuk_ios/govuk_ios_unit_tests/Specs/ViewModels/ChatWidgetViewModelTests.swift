import Foundation
import Testing

@testable import GOVKitTestUtilities
@testable import govuk_ios

@Suite
struct ChatWidgetViewModelTests {
    @Test
    func open_receivesExpectedUrl() throws {
        let link = ChatBanner.Link(title: "Title", url: URL(string: "https://www.test.com")!)
        let chat = ChatBanner(id: "1234", title: "Title", body: "Body", link: link)
        let mockUrlOpener = MockURLOpener()
        let sut = ChatWidgetViewModel(
            chat: chat,
            urlOpener: mockUrlOpener,
            dismiss: {}
        )
        sut.open()

        #expect(mockUrlOpener._receivedOpenIfPossibleUrl == URL(string: "https://www.test.com")!)
    }
}
