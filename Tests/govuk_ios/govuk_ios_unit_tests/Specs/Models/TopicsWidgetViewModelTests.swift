import Testing
import Factory

@testable import govuk_ios

@Suite
struct TopicsWidgetViewModelTests {
    
    let coreData = CoreDataRepository.arrangeAndLoad
    let topicService = MockTopicsService()

    @Test
    func initializeModel_downloadSuccess_returnsExpectedData() async throws {
        
        topicService._receivedFetchTopicsResult = MockTopicsService.testTopicsResult

        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            topicAction: { _ in },
            editAction: { _ in }
        )
        
        #expect(topicService._dataReceived == true)
        #expect(sut.downloadError == nil)
    }
    
    @Test
    func initializeModel_downloadFailure_returnsExpectedResult() async throws {
        topicService._receivedFetchTopicsResult = MockTopicsService.testTopicsFailure

        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            topicAction: { _ in },
            editAction: { _ in }
        )
        
        #expect(topicService._dataReceived == false)
        #expect(sut.downloadError == .decodingError)
    }
    
    @Test
    func didTapTopic_invokesExpectedAction() async throws {
        Container.shared.analyticsService.register { MockAnalyticsService() }
        var expectedValue = false
        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            topicAction: { _ in
                expectedValue = true
            },
            editAction: { _ in }
        )
        
        sut.didTapTopic(Topic(context: coreData.viewContext))
        #expect(expectedValue == true)
    }
    
    @Test
    func didTapEdit_invokesExpectedAction() async throws {
        Container.shared.analyticsService.register { MockAnalyticsService() }
        var expectedValue = false
        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            topicAction: { _ in },
            editAction: { _ in
                expectedValue = true
            }
        )
        
        sut.didTapEdit()
        #expect(expectedValue == true)
    }
    
    @Test
    func didTapTopic_sendsEvent() {
        let mockAnalyticsService = MockAnalyticsService()
        Container.shared.analyticsService.register { mockAnalyticsService }
        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            topicAction: { _ in },
            editAction: { _ in }
        )
        
        let testTopic = Topic(context: coreData.viewContext)
        testTopic.ref = "test"
        testTopic.title = "Title"
        sut.didTapTopic(testTopic)
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(mockAnalyticsService._trackedEvents.first?.params?["text"] as? String == "test")
    }
    
    @Test
    func didTapEdit_sendsEvent() {
        let mockAnalyticsService = MockAnalyticsService()
        Container.shared.analyticsService.register { mockAnalyticsService }
        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            topicAction: { _ in },
            editAction: { _ in }
        )
        
        sut.didTapEdit()
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(mockAnalyticsService._trackedEvents.first?.params?["text"] as? String == "EditTopics")
    }

}
