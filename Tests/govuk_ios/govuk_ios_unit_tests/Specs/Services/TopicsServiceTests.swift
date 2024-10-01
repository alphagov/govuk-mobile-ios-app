import Testing
@testable import govuk_ios

@Suite
struct TopicsServiceTests {
    var sut: TopicsService!
    var topicsServiceClient: MockTopicsServiceClient!
    
    init() {
        topicsServiceClient = MockTopicsServiceClient()
        sut = TopicsService(
            topicsServiceClient: topicsServiceClient
        )
    }
    
    @Test
    func topicsService_success_returnsExpectedData() async {
        let result = await withCheckedContinuation { continuation in
            sut.fetchTopics { result in
                continuation.resume(returning: result)
            }
            topicsServiceClient._receivedFetchTopicsCompletion?(testTopicsResult)
        }
        let topicsList = try? result.get()
        #expect(topicsList?.count == 3)
        #expect(topicsList?[0].title == "Driving & Transport")
        #expect(topicsList?[1].ref == "care")
    }
    
    @Test
    func topicsService_failure_returnsExpectedResult() async {
        let result = await withCheckedContinuation { continuation in
            sut.fetchTopics { result in
                continuation.resume(returning: result)
            }
            topicsServiceClient._receivedFetchTopicsCompletion?(testTopicsFailure)
        }

        #expect((try? result.get()) == nil)
        #expect(result.getError() == .apiUnavailable)
    }
}

private extension TopicsServiceTests {
    var testTopicsResult: Result<[Topic], TopicsListError> {
        let topics = [Topic(ref: "driving-transport", title: "Driving & Transport"),
                      Topic(ref: "care", title: "Care"),
                      Topic(ref: "business", title: "Business")
                      ]
        return .success(topics)
    }
    
    var testTopicsFailure: Result<[Topic], TopicsListError> {
        return .failure(.apiUnavailable)
    }
}

