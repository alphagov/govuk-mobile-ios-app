import Testing
import Factory

@testable import govuk_ios

@Suite
struct AllTopicsViewModelTests {
    let coreData = CoreDataRepository.arrangeAndLoad

    @Test
    func trackTopicAction_sendsEvent() {
        let mockAnalyticsService = MockAnalyticsService()
        let sut = AllTopicsViewModel(
            analyticsService: mockAnalyticsService,
            topicAction: { _ in },
            topicsService: MockTopicsService()
        )

        let testTopic = Topic(context: coreData.viewContext)
        testTopic.ref = "driving"
        testTopic.title = "Driving"
        sut.trackTopicAction(testTopic)

        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(mockAnalyticsService._trackedEvents.first?.params?["text"] as? String == "driving")
        #expect(mockAnalyticsService._trackedEvents.first?.params?["type"] as? String == "Button")
    }
}
