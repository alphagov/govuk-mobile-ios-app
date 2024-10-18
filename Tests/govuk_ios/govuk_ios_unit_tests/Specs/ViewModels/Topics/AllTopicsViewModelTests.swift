import Testing
import Factory

@testable import govuk_ios

@Suite
struct AllTopicsViewModelTests {
    let coreData = CoreDataRepository.arrangeAndLoad

    @Test
    func didTapTopic_invokesExpectedAction() {
        var expectedValue = false
        let topic = Topic(context: coreData.viewContext)

        let sut = AllTopicsViewModel(
            analyticsService: MockAnalyticsService(),
            topicAction: { _ in
                expectedValue = true
            },
            topics: [Topic()]
        )

        sut.didTapTopic(topic)
        #expect(expectedValue == true)
    }

    @Test
    func didTapTopic_sendsEvent() {
        let topic = Topic(context: coreData.viewContext)
        let mockAnalyticsService = MockAnalyticsService()
        let sut = AllTopicsViewModel(
            analyticsService: mockAnalyticsService,
            topicAction: { _ in },
            topics: [Topic()]
        )

        let testTopic = Topic(context: coreData.viewContext)
        testTopic.ref = "driving"
        testTopic.title = "Driving"
        sut.didTapTopic(testTopic)

        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(mockAnalyticsService._trackedEvents.first?.params?["text"] as? String == "driving")
    }
}
