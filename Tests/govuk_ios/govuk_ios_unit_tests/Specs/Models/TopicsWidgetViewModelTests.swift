import Testing

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

}
