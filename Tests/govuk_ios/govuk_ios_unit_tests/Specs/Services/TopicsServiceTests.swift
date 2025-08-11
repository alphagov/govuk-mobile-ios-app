import Foundation
import Testing
import GOVKit

@testable import GOVKitTestUtilities
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
            userDefaultsService: MockUserDefaultsService()
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
            topicsRepository: MockTopicsRepository(),
            analyticsService: MockAnalyticsService(),
            userDefaultsService: mockUserDefaults
        )

        #expect(mockUserDefaults.bool(forKey: .topicsOnboardingSeen) == false)

        sut.setHasOnboardedTopics()

        #expect(mockUserDefaults.bool(forKey: .topicsOnboardingSeen))
    }


    @Test
    func setHasCustomisedTopics_setsHasEditedTopicsToTrue() {

        let mockUserDefaults = MockUserDefaultsService()
        let mockAnalyticsService = MockAnalyticsService()
        let sut = TopicsService(
            topicsServiceClient: MockTopicsServiceClient(),
            topicsRepository: MockTopicsRepository(),
            analyticsService: mockAnalyticsService,
            userDefaultsService: mockUserDefaults
        )

        #expect(mockUserDefaults.bool(forKey: .customisedTopics) == false)
        #expect(mockAnalyticsService._trackSetUserPropertyReceivedProperty == nil)

        sut.setHasCustomisedTopics()

        #expect(mockUserDefaults.bool(forKey: .customisedTopics))
        #expect(mockUserDefaults.bool(forKey: .customisedTopics))
        #expect(mockAnalyticsService._trackSetUserPropertyReceivedProperty?.key == UserProperty.topicsCustomised.key)
        #expect(mockAnalyticsService._trackSetUserPropertyReceivedProperty?.value == UserProperty.topicsCustomised.value)
    }

    @Test(.serialized, arguments: [true, false])
    func hasOnboardedTopics_returnsExpectedResult(expectedValue: Bool) {

        let mockUserDefaults = MockUserDefaultsService()
        mockUserDefaults.set(bool: expectedValue, forKey: .topicsOnboardingSeen)

        let sut = TopicsService(
            topicsServiceClient: MockTopicsServiceClient(),
            topicsRepository: MockTopicsRepository(),
            analyticsService: MockAnalyticsService(),
            userDefaultsService: mockUserDefaults
        )

        #expect(sut.hasOnboardedTopics == expectedValue)
    }

    @Test(.serialized, arguments: [true, false])
    func hasTopicsBeenEdited_returnsExpectedResult(expectedValue: Bool) {
        let mockUserDefaults = MockUserDefaultsService()
        mockUserDefaults._stub(
            value: expectedValue,
            key: UserDefaultsKeys.customisedTopics.rawValue
        )

        let sut = TopicsService(
            topicsServiceClient: MockTopicsServiceClient(),
            topicsRepository: MockTopicsRepository(),
            analyticsService: MockAnalyticsService(),
            userDefaultsService: mockUserDefaults
        )

        #expect(sut.hasCustomisedTopics == expectedValue)
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
            topicsRepository: MockTopicsRepository(),
            analyticsService: MockAnalyticsService(),
            userDefaultsService: mockUserDefaults
        )

        sut.resetOnboarding()

        #expect(mockUserDefaults.value(forKey: UserDefaultsKeys.topicsOnboardingSeen) == nil)
        #expect(mockUserDefaults.value(forKey: UserDefaultsKeys.customisedTopics) == nil)
    }
}

