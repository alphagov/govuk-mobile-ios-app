import Foundation
import Testing
import GOVKit

@testable import govuk_ios

@Suite(.serialized)
final class TopicsServiceTests {
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
            analyticsService: mockAnalyticsService,
            userDefaultsService: MockUserDefaultsService(),
            topicsRepository: {
                self.mockTopicsRepository
            }
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
    func fetchAll_fetchesFromRepository() {
        _ = sut.fetchAll()
        #expect(mockTopicsRepository._didCallFetchAll)
    }

    @Test
    func fetchFavourites_fetchesFromRepository() {
        _ = sut.fetchFavourites()
        #expect(mockTopicsRepository._didCallFetchFavourites)
    }

    @Test
    func save_savesChangesToRepository() {
        sut.save()
        #expect(mockTopicsRepository._didCallSaveChanges)
    }

    @Test
    func fetchDetails_success_returnsExpectedData() async {
        await withCheckedContinuation { continuation in
            sut.fetchDetails(
                ref: "test_ref",
                completion: { _ in
                    continuation.resume()
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

        let mockUserDefaults = MockUserDefaultsService()

        let sut = TopicsService(
            topicsServiceClient: MockTopicsServiceClient(),
            analyticsService: MockAnalyticsService(),
            userDefaultsService: mockUserDefaults,
            topicsRepository: {
                MockTopicsRepository()
            }
        )

        #expect(mockUserDefaults.bool(forKey: .topicsOnboardingSeen) == false)

        sut.setHasOnboardedTopics()

        #expect(mockUserDefaults.bool(forKey: .topicsOnboardingSeen))
    }

    @Test(.serialized, arguments: [true, false])
    func hasOnboardedTopics_returnsExpectedResult(expectedValue: Bool) {

        let mockUserDefaults = MockUserDefaultsService()
        mockUserDefaults.set(bool: expectedValue, forKey: .topicsOnboardingSeen)

        let sut = TopicsService(
            topicsServiceClient: MockTopicsServiceClient(),
            analyticsService: MockAnalyticsService(),
            userDefaultsService: mockUserDefaults,
            topicsRepository: {
                MockTopicsRepository()
            }
        )

        #expect(sut.hasOnboardedTopics == expectedValue)
    }

    @Test
    func resetOnboarding_resetsPreferences() {
        let mockUserDefaults = MockUserDefaultsService()
        mockUserDefaults._stub(
            value: true,
            key: UserDefaultsKeys.topicsOnboardingSeen.rawValue
        )
        mockUserDefaults._stub(
            value: true,
            key: UserDefaultsKeys.customisedTopics.rawValue
        )
        let sut = TopicsService(
            topicsServiceClient: MockTopicsServiceClient(),
            analyticsService: MockAnalyticsService(),
            userDefaultsService: mockUserDefaults,
            topicsRepository: {
                MockTopicsRepository()
            }
        )

        sut.resetOnboarding()

        #expect(mockUserDefaults.value(forKey: UserDefaultsKeys.topicsOnboardingSeen) == nil)
        #expect(mockUserDefaults.value(forKey: UserDefaultsKeys.customisedTopics) == nil)
    }

    @Test
    func rollBack_rollsBackRepository() {
        sut.rollback()
        #expect(mockTopicsRepository._didCallRollback)
    }
}

