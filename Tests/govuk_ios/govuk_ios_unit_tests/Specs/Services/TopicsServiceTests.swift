import Foundation
import Testing
import GOVKit
import FactoryKit

@testable import govuk_ios

@Suite(.serialized)
struct TopicsServiceTests {
    var sut: TopicsService!
    var mockTopicsServiceClient: MockTopicsServiceClient!
    var mockAnalyticsService: MockAnalyticsService!

    init() {
        mockTopicsServiceClient = MockTopicsServiceClient()
        mockAnalyticsService = MockAnalyticsService()
        sut = TopicsService(
            topicsServiceClient: mockTopicsServiceClient,
            analyticsService: mockAnalyticsService,
            userDefaultsService: MockUserDefaultsService()
        )
    }

    @Test
    func downloadTopicsList_success_returnsExpectedData() async {
        let mockTopicsRepository = MockTopicsRepository()
        Container.shared.topicsRepository.register {
            mockTopicsRepository
        }
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
        Container.shared.topicsService.reset()
    }

    @Test
    func downloadTopicsList_failure_returnsExpectedResult() async {
        let mockTopicsRepository = MockTopicsRepository()
        Container.shared.topicsRepository.register {
            mockTopicsRepository
        }
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
        Container.shared.topicsService.reset()
    }

    @Test
    func fetchAll_fetchesFromRepository() {
        let mockTopicsRepository = MockTopicsRepository()
        Container.shared.topicsRepository.register {
            mockTopicsRepository
        }
        _ = sut.fetchAll()
        #expect(mockTopicsRepository._didCallFetchAll)
        Container.shared.topicsService.reset()
    }

    @Test
    func fetchFavourites_fetchesFromRepository() {
        let mockTopicsRepository = MockTopicsRepository()
        Container.shared.topicsRepository.register {
            mockTopicsRepository
        }
        _ = sut.fetchFavourites()
        #expect(mockTopicsRepository._didCallFetchFavourites)
        Container.shared.topicsService.reset()
    }

    @Test
    func save_savesChangesToRepository() {
        let mockTopicsRepository = MockTopicsRepository()
        Container.shared.topicsRepository.register {
            mockTopicsRepository
        }
        sut.save()
        #expect(mockTopicsRepository._didCallSaveChanges)
        Container.shared.topicsService.reset()
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
            userDefaultsService: mockUserDefaults
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
            userDefaultsService: mockUserDefaults
        )

        #expect(sut.hasOnboardedTopics == expectedValue)
    }

    @Test
    func resetOnboaring_resetsPreferences() {
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
            userDefaultsService: mockUserDefaults
        )

        sut.resetOnboarding()

        #expect(mockUserDefaults.value(forKey: UserDefaultsKeys.topicsOnboardingSeen) == nil)
        #expect(mockUserDefaults.value(forKey: UserDefaultsKeys.customisedTopics) == nil)
    }
}

