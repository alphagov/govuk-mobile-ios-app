import Testing

@testable import govuk_ios

struct EditTopicsViewModelTests {
    
    let coreData = CoreDataRepository.arrangeAndLoad
    let topicService = MockTopicsService()
    let analyticsService = MockAnalyticsService()
    
    @Test
    func updateFavorites_doesSaveAndDismiss() async throws {
        var dismissActionCalled = false
        let sut = EditTopicsViewModel(
            topics: [],
            topicsService: topicService,
            analyticsService: analyticsService,
            dismissAction: {
                dismissActionCalled = true
            }
        )
        
        sut.updateFavoriteTopics()
        #expect(topicService._didUpdateFavoritesCalled)
        #expect(dismissActionCalled)
    }
    
    @Test func initViewModel_doesCreateSectionsCorrectly() async throws {
        let sut = EditTopicsViewModel(
            topics: createTopics(),
            topicsService: topicService,
            analyticsService: analyticsService,
            dismissAction: { }
        )
        
        try #require(sut.sections.count == 1)
        try #require(sut.sections[0].rows.count == 3)
        let row = try #require(sut.sections[0].rows[0] as? ToggleRow)
        #expect(row.title == "title0")
        row.action(true)
        #expect(sut.topics[0].isFavorite)
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
