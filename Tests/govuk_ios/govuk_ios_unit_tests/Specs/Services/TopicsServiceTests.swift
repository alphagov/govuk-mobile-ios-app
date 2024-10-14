import Testing
@testable import govuk_ios

@Suite
struct TopicsServiceTests {
    var sut: TopicsService!
    var topicsServiceClient: MockTopicsServiceClient!
    var topicsRepository: MockTopicsRepository!
    
    init() {
        topicsServiceClient = MockTopicsServiceClient()
        topicsRepository = MockTopicsRepository()
        sut = TopicsService(
            topicsServiceClient: topicsServiceClient,
            topicsRepository: topicsRepository
        )
    }
    
    @Test
    func topicsService_success_returnsExpectedData() async {
        let result = await withCheckedContinuation { continuation in
            sut.downloadTopicsList { result in
                continuation.resume(returning: result)
            }
            topicsServiceClient._receivedFetchTopicsCompletion?(
                MockTopicsService.testTopicsResult
            )
            
        }
        let topicsList = try? result.get()
        #expect(topicsList?.count == 3)
        #expect(topicsRepository._didCallSaveTopicsList == true)
    }
    
    @Test
    func topicsService_failure_returnsExpectedResult() async {
        let result = await withCheckedContinuation { continuation in
            sut.downloadTopicsList { result in
                continuation.resume(returning: result)
            }
            topicsServiceClient._receivedFetchTopicsCompletion?(
                MockTopicsService.testTopicsFailure
            )
        }

        #expect((try? result.get()) == nil)
        #expect(result.getError() == .decodingError)
        #expect(topicsRepository._didCallSaveTopicsList == false)
    }
    
    @Test
    func fetchAllTopics_fetchesFromRepository() async {
        _ = sut.fetchAllTopics()
        #expect(topicsRepository._didCallFetchAll ?? false)
    }
    
    @Test
    func fetchFavoriteTopics_fetchesFromRepository() async {
        _ = sut.fetchFavoriteTopics()
        #expect(topicsRepository._didCallFetchFavorites)
    }
    
    @Test
    func updateFavorites_savesChangesToRepository() async {
        sut.updateFavoriteTopics()
        #expect(topicsRepository._didCallSaveChanges)
    }
}

