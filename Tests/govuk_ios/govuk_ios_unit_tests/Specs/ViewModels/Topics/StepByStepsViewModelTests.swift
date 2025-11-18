import Testing

@testable import GOVKit

@testable import govuk_ios

struct StepByStepsViewModelTests {

    let mockTopicsService = MockTopicsService()
    let mockAnalyticsService = MockAnalyticsService()
    let mockActivityService = MockActivityService()
    let mockURLOpener = MockURLOpener()

    @Test
    func init_hasCorrectParameters() {
        let sut = StepByStepsViewModel(
            content: [.arrange, .arrange],
            analyticsService: mockAnalyticsService,
            activityService: mockActivityService,
            selectedAction: { _ in }
        )

        #expect(sut.title == "Step-by-step guides")
        #expect(sut.description == nil)
        #expect(sut.sections.count == 1)
        #expect(sut.sections.first?.rows.count == 2)
    }

    @Test
    func rowAction_hasCorrectParameters() {
        var selectedContent: TopicDetailResponse.Content?
        let expectedContent = TopicDetailResponse.Content.arrange
        let mockAnalyticsServicez = MockAnalyticsService()
        let sut = StepByStepsViewModel(
            content: [expectedContent],
            analyticsService: mockAnalyticsServicez,
            activityService: mockActivityService,
            selectedAction: { content in
                    selectedContent = content
            }
        )

        let section = sut.sections.first
        let row = section?.rows.first as? LinkRow
        row?.action()

        #expect(selectedContent?.url == expectedContent.url)
        #expect(mockAnalyticsServicez._trackedEvents.count == 2)
        #expect(mockActivityService._receivedSaveActivity?.id == expectedContent.url.absoluteString)
    }
}
