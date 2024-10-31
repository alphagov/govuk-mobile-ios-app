import Foundation
import Testing

@testable import govuk_ios

@Suite
struct TopicsServiceTests {
    var sut: TopicsService!
    var mockTopicsServiceClient: MockTopicsServiceClient!
    var mockTopicsRepository: MockTopicsRepository!

    init() {
        mockTopicsServiceClient = MockTopicsServiceClient()
        mockTopicsRepository = MockTopicsRepository()
        sut = TopicsService(
            topicsServiceClient: mockTopicsServiceClient,
            topicsRepository: mockTopicsRepository,
            userDefaults: UserDefaults()
        )
    }

    @Test
    func downloadTopicsList_success_returnsExpectedData() async {
        let result = await withCheckedContinuation { continuation in
            sut.downloadTopicsList { result in
                continuation.resume(returning: result)
            }
            mockTopicsServiceClient._receivedFetchTopicsCompletion?(
                .success(TopicResponseItem.arrangeMultiple)
            )

        }
        let topicsList = try? result.get()
        #expect(topicsList?.count == 3)
        #expect(mockTopicsRepository._didCallSaveTopicsList == true)
    }

    @Test
    func downloadTopicsList_failure_returnsExpectedResult() async {
        let result = await withCheckedContinuation { continuation in
            sut.downloadTopicsList { result in
                continuation.resume(returning: result)
            }
            mockTopicsServiceClient._receivedFetchTopicsCompletion?(
                .failure(.decodingError)
            )
        }

        #expect((try? result.get()) == nil)
        #expect(result.getError() == .decodingError)
        #expect(mockTopicsRepository._didCallSaveTopicsList == false)
    }

    @Test
    func fetchAllTopics_fetchesFromRepository() async {
        _ = sut.fetchAllTopics()
        #expect(mockTopicsRepository._didCallFetchAll)
    }

    @Test
    func fetchFavoriteTopics_fetchesFromRepository() async {
        _ = sut.fetchFavoriteTopics()
        #expect(mockTopicsRepository._didCallFetchFavorites)
    }

    @Test
    func updateFavorites_savesChangesToRepository() async {
        sut.updateFavoriteTopics()
        #expect(mockTopicsRepository._didCallSaveChanges)
    }

    @Test
    func fetchTopicDetails_success_returnsExpectedData() async {
        _ = await withCheckedContinuation { continuation in
            sut.fetchTopicDetails(
                topicRef: "test_ref",
                completion: { result in
                    continuation.resume(returning: result)
                }
            )
            mockTopicsServiceClient._receivedFetchTopicsDetailsCompletion?(
                .success(.arrange())
            )
        }
        #expect(mockTopicsServiceClient._receivedFetchTopicsDetailsTopicRef == "test_ref")
    }

    @Test
    func setHasOnboardedTopics_setsOnboardingToTrue() {

        let mockUserDefaults = MockUserDefaults()

        let sut = TopicsService(
            topicsServiceClient: MockTopicsServiceClient(),
            topicsRepository: MockTopicsRepository(),
            userDefaults: mockUserDefaults
        )

        #expect(sut.hasOnboardedTopics == false)

        sut.setHasOnboardedTopics()

        #expect(sut.hasOnboardedTopics == true)
    }


    @Test
    func setHasEditedTopics_setsHasEditedTopicsToTrue() {

        let mockUserDefaults = MockUserDefaults()

        let sut = TopicsService(
            topicsServiceClient: MockTopicsServiceClient(),
            topicsRepository: MockTopicsRepository(),
            userDefaults: mockUserDefaults
        )

        #expect(sut.hasTopicsBeenEdited == false)

        sut.setHasEditedTopics()

        #expect(sut.hasTopicsBeenEdited == true)
        #expect(mockUserDefaults.bool(forKey: .hasEditedTopics) == true)
    }

}
