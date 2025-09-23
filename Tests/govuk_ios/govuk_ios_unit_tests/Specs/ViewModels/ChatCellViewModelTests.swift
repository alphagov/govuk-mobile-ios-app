import Foundation
import UIKit
import Testing
import GOVKit

@testable import govuk_ios
@testable import GOVKitTestUtilities

@Suite
struct ChatCellViewModelTests {
    @Test
    func openURL_responseLink_opensURLAndTracksEvent() async {
        await confirmation() { confirmation in
            let mockAnalyticsService = MockAnalyticsService()
            let sut = ChatCellViewModel(
                message: "test",
                id: UUID().uuidString,
                type: .answer,
                openURLAction: { _ in confirmation() },
                analyticsService: mockAnalyticsService
            )

            sut.openURL(
                url: URL(string: "https://wwww.gov.uk")!,
                type: .responseLink
            )
            #expect(mockAnalyticsService._trackedEvents.count == 1)
            #expect(
                mockAnalyticsService
                    ._trackedEvents.first?.params?["text"] as? String == "Response Link Opened"
            )
        }
    }

    @Test
    func openURL_sourceLink_opensURLAndTracksEvent() async {
        await confirmation() { confirmation in
            let mockAnalyticsService = MockAnalyticsService()
            let sut = ChatCellViewModel(
                message: "test",
                id: UUID().uuidString,
                type: .answer,
                openURLAction: { _ in confirmation() },
                analyticsService: mockAnalyticsService
            )

            sut.openURL(
                url: URL(string: "https://wwww.gov.uk")!,
                type: .sourceLink
            )
            #expect(mockAnalyticsService._trackedEvents.count == 1)
            #expect(
                mockAnalyticsService
                    ._trackedEvents.first?.params?["text"] as? String == "Source Link Opened"
            )
        }
    }

    @Test
    func trackSourceListToggle_expanded_tracksEvent() async {
        let mockAnalyticsService = MockAnalyticsService()
        let sut = ChatCellViewModel(
            message: "test",
            id: UUID().uuidString,
            type: .answer,
            openURLAction: { _ in },
            analyticsService: mockAnalyticsService
        )

        sut.trackSourceListToggle(isExpanded: true)
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(
            mockAnalyticsService
                ._trackedEvents.first?.params?["text"] as? String == "Expanded"
        )
    }

    @Test
    func trackSourceListToggle_hidden_doesntTrackEvent() async {
        let mockAnalyticsService = MockAnalyticsService()
        let sut = ChatCellViewModel(
            message: "test",
            id: UUID().uuidString,
            type: .answer,
            openURLAction: { _ in },
            analyticsService: mockAnalyticsService
        )

        sut.trackSourceListToggle(isExpanded: false)
        #expect(mockAnalyticsService._trackedEvents.count == 0)
    }

    @Test
    func copytoClipboard_copiesExpectedText() async {
        let mockAnalyticsService = MockAnalyticsService()
        let markdownText = """
            ## Heading
            * Bullet 1
            * Bullet 2
            # Heading 2
            paragraph
            """
        let source = Source(title: "Source Title", url: "https://example.com")


        let sut = ChatCellViewModel(
            message: markdownText,
            id: UUID().uuidString,
            type: .answer,
            sources: [source],
            openURLAction: { _ in },
            analyticsService: mockAnalyticsService
        )
        sut.copyToClipboard()

        let expectedText = """
            Heading
            
              - Bullet 1
              - Bullet 2
            
            Heading 2
            
            paragraph
            
            GOV.UK Chat can make mistakes. Check GOV.UK pages for important information.
            
            https://example.com
            """

        #expect(UIPasteboard.general.string ?? "" == expectedText)
    }

    @Test(arguments: zip(
        [
            ChatCellType.question,
            ChatCellType.answer,
        ],
        [
            "Chat Question",
            "Chat Answer"
        ]
    ))
    func copytoClipboard_question_tracksEvent(type: ChatCellType, section: String) async {
        let mockAnalyticsService = MockAnalyticsService()
        let sut = ChatCellViewModel(
            message: "Question",
            id: UUID().uuidString,
            type: type,
            sources: [],
            openURLAction: { _ in },
            analyticsService: mockAnalyticsService
        )
        sut.copyToClipboard()
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(
            mockAnalyticsService
                ._trackedEvents.first?.params?["text"] as? String == "Copy to clipboard"
        )
        #expect(
            mockAnalyticsService
                ._trackedEvents.first?.params?["section"] as? String == section
        )
        #expect(
            mockAnalyticsService
                ._trackedEvents.first?.params?["action"] as? String == "Copy"
        )
    }
}
