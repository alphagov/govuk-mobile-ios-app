import Foundation
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
}
