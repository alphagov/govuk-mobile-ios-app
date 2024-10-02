import Testing
import Factory

@testable import govuk_ios

@Suite
struct TopicsWidgetViewModelTests {

    @Test
    func fetchTopics_success_returnsExpectedData() async throws {
        let topicService = MockTopicsService()
        topicService._receivedFetchTopicsResult = MockTopicsService.testTopicsResult

        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            topicAction: { _ in }
        )
        let result = await withCheckedContinuation { continuation in
            sut.fetchTopics { result in
                continuation.resume(returning: result)
            }
        }
        
        let topics = try? result.get()
        #expect(topics?.count == 3)
        #expect(topics?.first?.ref == "driving-transport")
    }
    
    @Test
    func fetchTopics_failure_returnsExpectedResult() async throws {
        let topicService = MockTopicsService()
        topicService._receivedFetchTopicsResult = MockTopicsService.testTopicsFailure

        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            topicAction: { _ in }
        )
        let result = await withCheckedContinuation { continuation in
            sut.fetchTopics { result in
                continuation.resume(returning: result)
            }
        }
        
        let topics = try? result.get()
        let error = result.getError()
        #expect(topics == nil)
        #expect(error == .apiUnavailable)
        
    }
    
    @Test
    func didTapTopic_invokesExpectedAction() async throws {
        let topicService = MockTopicsService()
        Container.shared.analyticsService.register { MockAnalyticsService() }
        var expectedValue = false
        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            topicAction: { _ in
                expectedValue = true
            }
        )
        
        sut.didTapTopic(Topic(ref: "test", title: "Title"))
        #expect(expectedValue == true)
    }
    
    @Test
    func didTapTopic_sendsEvent() async throws {
        let topicService = MockTopicsService()
        let mockAnalyticsService = MockAnalyticsService()
        Container.shared.analyticsService.register { mockAnalyticsService }
        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            topicAction: { _ in }
        )
        
        sut.didTapTopic(Topic(ref: "test", title: "Title"))
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(mockAnalyticsService._trackedEvents.first?.params?["text"] as? String == "test")
    }

}
