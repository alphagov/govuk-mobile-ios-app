import Testing

@testable import govuk_ios

struct EditTopicsViewModelTests {

    let coreData = CoreDataRepository.arrangeAndLoad
    let mockTopicService = MockTopicsService()
    let mockAnalyticsService = MockAnalyticsService()

    @Test
    func dismissAction_callsDismiss() throws {
        var dismissActionCalled = false
        let sut = EditTopicsViewModel(
            topics: [],
            topicsService: mockTopicService,
            analyticsService: mockAnalyticsService,
            dismissAction: {
                dismissActionCalled = true
            }
        )

        sut.dismissAction()
        #expect(dismissActionCalled)
    }

    @Test
    func initViewModel_doesCreateSectionsCorrectly() throws {
        let sut = EditTopicsViewModel(
            topics: createTopics(),
            topicsService: mockTopicService,
            analyticsService: mockAnalyticsService,
            dismissAction: { }
        )

        try #require(sut.sections.count == 1)
        try #require(sut.sections[0].rows.count == 3)
        let row = try #require(sut.sections[0].rows[0] as? ToggleRow)
        #expect(row.title == "title0")
        row.action(true)
        #expect(sut.topics[0].isFavorite)
        #expect(mockTopicService._updateFavoriteTopicsCalled)
    }
}

private extension EditTopicsViewModelTests {
    func createTopics() -> [Topic] {
        var topics = [Topic]()
        for index in 0..<3 {
            let topic = Topic(context: coreData.viewContext)
            topic.ref = "ref\(index)"
            topic.title = "title\(index)"
            topic.isFavorite = false
            topics.append(topic)
        }
        return topics
    }
}
