import Foundation
import Testing

@testable import govuk_ios

@Suite(.serialized)
struct TopicsServiceTests {
    var sut: TopicsService!
    var mockTopicsServiceClient: MockTopicsServiceClient!
    var mockTopicsRepository: MockTopicsRepository!
    var mockAnalyticsService: MockAnalyticsService!

    init() {
        mockTopicsServiceClient = MockTopicsServiceClient()
        mockTopicsRepository = MockTopicsRepository()
        mockAnalyticsService = MockAnalyticsService()
        sut = TopicsService(
            topicsServiceClient: mockTopicsServiceClient,
            topicsRepository: mockTopicsRepository,
            analyticsService: mockAnalyticsService,
            userDefaults: MockUserDefaults()
        )
    }

    @Test
    func downloadTopicsList_success_returnsExpectedData() async {
        let result = await withCheckedContinuation { continuation in
            sut.fetchRemoteList { result in
                continuation.resume(returning: result)
            }
            mockTopicsServiceClient._receivedFetchListCompletion?(
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
            sut.fetchRemoteList { result in
                continuation.resume(returning: result)
            }
            mockTopicsServiceClient._receivedFetchListCompletion?(
                .failure(.decodingError)
            )
        }

        #expect((try? result.get()) == nil)
        #expect(result.getError() == .decodingError)
        #expect(mockTopicsRepository._didCallSaveTopicsList == false)
    }

    @Test
    func fetchAll_fetchesFromRepository() async {
        _ = sut.fetchAll()
        #expect(mockTopicsRepository._didCallFetchAll)
    }

    @Test
    func fetchFavourites_fetchesFromRepository() async {
        _ = sut.fetchFavourites()
        #expect(mockTopicsRepository._didCallFetchFavourites)
    }

    @Test
    func save_savesChangesToRepository() async {
        sut.save()
        #expect(mockTopicsRepository._didCallSaveChanges)
    }

    @Test
    func fetchDetails_success_returnsExpectedData() async {
        _ = await withCheckedContinuation { continuation in
            sut.fetchDetails(
                ref: "test_ref",
                completion: { result in
                    continuation.resume(returning: result)
                }
            )
            mockTopicsServiceClient._receivedFetchDetailsCompletion?(
                .success(.arrange())
            )
        }
        #expect(mockTopicsServiceClient._receivedFetchDetailsRef == "test_ref")
    }

    @Test
    func setHasOnboardedTopics_setsOnboardingToTrue() {

        let mockUserDefaults = MockUserDefaults()

        let sut = TopicsService(
            topicsServiceClient: MockTopicsServiceClient(),
            topicsRepository: MockTopicsRepository(),
            analyticsService: MockAnalyticsService(),
            userDefaults: mockUserDefaults
        )

        #expect(mockUserDefaults.bool(forKey: .topicsOnboardingSeen) == false)

        sut.setHasOnboardedTopics()

        #expect(mockUserDefaults.bool(forKey: .topicsOnboardingSeen))
    }


    @Test
    func setHasPersonalisedTopics_setsHasEditedTopicsToTrue() {

        let mockUserDefaults = MockUserDefaults()
        let mockAnalyticsService = MockAnalyticsService()
        let sut = TopicsService(
            topicsServiceClient: MockTopicsServiceClient(),
            topicsRepository: MockTopicsRepository(),
            analyticsService: mockAnalyticsService,
            userDefaults: mockUserDefaults
        )

        #expect(mockUserDefaults.bool(forKey: .personalisedTopics) == false)
        #expect(mockAnalyticsService._trackSetUserPropertyReceivedProperty == nil)

        sut.setHasPersonalisedTopics()

        #expect(mockUserDefaults.bool(forKey: .personalisedTopics))
        #expect(mockUserDefaults.bool(forKey: .personalisedTopics))
        #expect(mockAnalyticsService._trackSetUserPropertyReceivedProperty?.key == "topics_personalised")
    }

    @Test(.serialized, arguments: [true, false])
    func hasOnboardedTopics_returnsExpectedResult(expectedValue: Bool) {

        let mockUserDefaults = MockUserDefaults()
        mockUserDefaults.set(bool: expectedValue, forKey: .topicsOnboardingSeen)

        let sut = TopicsService(
            topicsServiceClient: MockTopicsServiceClient(),
            topicsRepository: MockTopicsRepository(),
            analyticsService: MockAnalyticsService(),
            userDefaults: mockUserDefaults
        )

        #expect(sut.hasOnboardedTopics == expectedValue)
    }

    @Test(.serialized, arguments: [true, false])
    func hasTopicsBeenEdited_returnsExpectedResult(expectedValue: Bool) {
        let mockUserDefaults = MockUserDefaults()
        mockUserDefaults.setValue(expectedValue, forKey: UserDefaultsKeys.personalisedTopics.rawValue)
        mockUserDefaults.synchronize()

        let sut = TopicsService(
            topicsServiceClient: MockTopicsServiceClient(),
            topicsRepository: MockTopicsRepository(),
            analyticsService: MockAnalyticsService(),
            userDefaults: mockUserDefaults
        )

        #expect(sut.hasPersonalisedTopics == expectedValue)
    }
}
