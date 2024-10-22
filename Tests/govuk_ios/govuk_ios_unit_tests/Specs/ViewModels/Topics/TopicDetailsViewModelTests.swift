import Testing

@testable import govuk_ios

struct TopicDetailsViewModelTests {

    let mockTopicsService = MockTopicsService()
    let mockAnalyticsService = MockAnalyticsService()
    let mockActivityService = MockActivityService()
    let mockURLOpener = MockURLOpener()
    
    @Test
    func initViewModel_noUnpopularContent_doesCreateSectionsCorrectly() async throws {
        mockTopicsService._receivedTopicDetailsResult = MockTopicsService.createTopicDetails(fileName: "NoUnpopularContent")
        let sut = TopicDetailViewModel(
            topic: mockTopicsService.mockTopics[0],
            topicsService: mockTopicsService,
            analyticsService: mockAnalyticsService,
            activityService: mockActivityService,
            urlOpener: mockURLOpener,
            subtopicAction: { _ in },
            stepByStepAction: { _ in }
        )
        print("")
        try #require(sut.sections.count == 3)
        #expect(sut.sections[0].heading == "Popular pages in this topic")
        #expect(sut.sections[1].heading == "Step by step guides")
        #expect(sut.sections[2].heading == "Browse")
        
        #expect(sut.sections[0].rows.first is LinkRow)
        #expect(sut.sections[1].rows.last is LinkRow)
        #expect(sut.sections[2].rows.first is NavigationRow)
    }
    
    @Test
    func initViewModel_fiveStepByStep_doesCreateSectionsCorrectly() async throws {
        mockTopicsService._receivedTopicDetailsResult = MockTopicsService.createTopicDetails(fileName: "FiveStepByStep")
        let sut = TopicDetailViewModel(
            topic: mockTopicsService.mockTopics[0],
            topicsService: mockTopicsService,
            analyticsService: mockAnalyticsService,
            activityService: mockActivityService,
            urlOpener: mockURLOpener,
            subtopicAction: { _ in },
            stepByStepAction: { _ in }
        )
        
        try #require(sut.sections.count == 3)
        #expect(sut.sections[0].heading == "Popular pages in this topic")
        #expect(sut.sections[1].heading == "Step by step guides")
        #expect(sut.sections[2].heading == "Browse")
        
        #expect(sut.sections[0].rows.first is LinkRow)
        
        #expect(sut.sections[1].rows.count == 4)
        #expect(sut.sections[1].rows.first is LinkRow)
        #expect(sut.sections[1].rows.last is NavigationRow)
        #expect(sut.sections[1].rows.last?.title == "See all")
        
        #expect(sut.sections[2].rows.first is NavigationRow)
    }
    
    @Test
    func initViewModel_hasUnpopularContent_doesCreateSectionsCorrectly() async throws {
        mockTopicsService._receivedTopicDetailsResult = MockTopicsService.createTopicDetails(fileName: "UnpopularContent")
        let sut = TopicDetailViewModel(
            topic: mockTopicsService.mockTopics[0],
            topicsService: mockTopicsService,
            analyticsService: mockAnalyticsService,
            activityService: mockActivityService,
            urlOpener: mockURLOpener,
            subtopicAction: { _ in },
            stepByStepAction: { _ in }
        )
        
        try #require(sut.sections.count == 4)
        #expect(sut.sections[0].heading == "Popular pages in this topic")
        #expect(sut.sections[1].heading == "Step by step guides")
        #expect(sut.sections[2].heading == "Services and information")
        #expect(sut.sections[3].heading == "Browse")
        
        #expect(sut.sections[0].rows.first is LinkRow)
        #expect(sut.sections[1].rows.first is LinkRow)
        #expect(sut.sections[2].rows.last is LinkRow)
        #expect(sut.sections[2].rows.count == 3)
        #expect(sut.sections[3].rows.first is NavigationRow)
    }
    
    @Test
    func tappingSubtopic_doesFireNavigationEvent() async throws {
        var didNavigate = false
        mockTopicsService._receivedTopicDetailsResult = MockTopicsService.createTopicDetails(fileName: "UnpopularContent")
        let sut = TopicDetailViewModel(
            topic: MockDisplayableTopic(),
            topicsService: mockTopicsService,
            analyticsService: mockAnalyticsService,
            activityService: mockActivityService,
            urlOpener: mockURLOpener,
            subtopicAction: { _ in
                didNavigate = true
            },
            stepByStepAction: { _ in }
        )
        
        try #require(sut.sections.count == 4)
        let subTopicRow = try #require(sut.sections[3].rows.first as? NavigationRow)
        subTopicRow.action()
        #expect(didNavigate)
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(mockAnalyticsService._trackedEvents.first?.params?["text"] as? String == "Driving")
    }
    
    @Test
    func tappingContent_doesFireLinkEvent() async throws {
        mockTopicsService._receivedTopicDetailsResult = MockTopicsService.createTopicDetails(fileName: "UnpopularContent")
        let sut = TopicDetailViewModel(
            topic: MockDisplayableTopic(),
            topicsService: mockTopicsService,
            analyticsService: mockAnalyticsService,
            activityService: mockActivityService,
            urlOpener: mockURLOpener,
            subtopicAction: { _ in },
            stepByStepAction: { _ in }
        )
        
        try #require(sut.sections.count == 4)
        let contentRow = try #require(sut.sections[0].rows.first as? LinkRow)
        contentRow.action()
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(mockAnalyticsService._trackedEvents.first?.params?["url"] as? String == "https://www.gov.uk/view-driving-licence")
    }
}
