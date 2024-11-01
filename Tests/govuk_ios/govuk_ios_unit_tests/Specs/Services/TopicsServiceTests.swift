import Foundation
import Testing

@testable import govuk_ios

@Suite(.serialized)
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
            userDefaults: MockUserDefaults()
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
    func save_savesChangesToRepository() async {
        sut.save()
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

        #expect(mockUserDefaults.bool(forKey: .hasOnboardedTopics) == false)

        sut.setHasOnboardedTopics()

        #expect(mockUserDefaults.bool(forKey: .hasOnboardedTopics))
    }


    @Test
    func setHasEditedTopics_setsHasEditedTopicsToTrue() {

        let mockUserDefaults = MockUserDefaults()

        let sut = TopicsService(
            topicsServiceClient: MockTopicsServiceClient(),
            topicsRepository: MockTopicsRepository(),
            userDefaults: mockUserDefaults
        )

        #expect(mockUserDefaults.bool(forKey: .hasEditedTopics) == false)

        sut.setHasEditedTopics()

        #expect(mockUserDefaults.bool(forKey: .hasEditedTopics))
    }

    @Test(.serialized, arguments: [true, false])
    func hasOnboardedTopics_returnsExpectedResult(expectedValue: Bool) {

        let mockUserDefaults = MockUserDefaults()
        mockUserDefaults.set(bool: expectedValue, forKey: .hasOnboardedTopics)

        let sut = TopicsService(
            topicsServiceClient: MockTopicsServiceClient(),
            topicsRepository: MockTopicsRepository(),
            userDefaults: mockUserDefaults
        )

        #expect(sut.hasOnboardedTopics == expectedValue)
    }

    @Test(.serialized, arguments: [true, false])
    func hasTopicsBeenEdited_returnsExpectedResult(expectedValue: Bool) {
        let mockUserDefaults = MockUserDefaults()
        mockUserDefaults.setValue(expectedValue, forKey: UserDefaultsKeys.hasEditedTopics.rawValue)
        mockUserDefaults.synchronize()

        let sut = TopicsService(
            topicsServiceClient: MockTopicsServiceClient(),
            topicsRepository: MockTopicsRepository(),
            userDefaults: mockUserDefaults
        )

        #expect(sut.hasTopicsBeenEdited == expectedValue)
    }
}
