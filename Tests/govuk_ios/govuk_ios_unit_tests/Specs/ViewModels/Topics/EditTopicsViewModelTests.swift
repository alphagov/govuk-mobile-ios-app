import Testing

@testable import GOVKitTestUtilities
@testable import govuk_ios

struct EditTopicsViewModelTests {
    let coreData = CoreDataRepository.arrangeAndLoad
    let mockTopicService = MockTopicsService()
    let mockAnalyticsService = MockAnalyticsService()

    @Test
    func init_withTopics_createsTopicCardsCorrectly() {
        mockTopicService._stubbedFetchAllTopics = createTopics()
        let sut = EditTopicsViewModel(
            topicsService: mockTopicService,
            analyticsService: mockAnalyticsService
        )

        #expect(sut.topicSelectionCards.count == 3)
        #expect((sut.topicSelectionCards[0] as Any) is TopicSelectionCardViewModel)
    }

    @Test
    func tapAction_savesTopic() {
        mockTopicService._stubbedFetchAllTopics = createTopics()
        let sut = EditTopicsViewModel(
            topicsService: mockTopicService,
            analyticsService: mockAnalyticsService
        )

        let topicCard = sut.topicSelectionCards[0]
        topicCard.tapAction(true)
        #expect(mockTopicService._saveCalled)
        let trackedEvent = mockAnalyticsService._trackedEvents.first
        #expect(trackedEvent?.params?["text"] as? String == topicCard.title)
        #expect(trackedEvent?.params?["type"] as? String == "Button")
        #expect(trackedEvent?.params?["section"] as? String == "Edit topics")
        #expect(trackedEvent?.params?["action"] as? String == "Selected")
    }
}

private extension EditTopicsViewModelTests {
    func createTopics() -> [Topic] {
        var topics = [Topic]()
        for index in 0..<3 {
            let topic = Topic(context: coreData.backgroundContext)
            topic.ref = "ref\(index)"
            topic.title = "title\(index)"
            topic.isFavourite = false
            topics.append(topic)
        }
        return topics
    }
}
