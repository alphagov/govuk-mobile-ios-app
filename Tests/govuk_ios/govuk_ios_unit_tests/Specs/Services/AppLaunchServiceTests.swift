import Foundation
import Testing

@testable import govuk_ios

@Suite
struct AppLaunchServiceTests {
    @Test
    func fetch_configFetchFail_remoteJson_returnsExpectedResult() async {
        let mockConfigService = MockAppConfigService()
        let mockTopicsService = MockTopicsService()
        let mockRemoteConfigService = MockRemoteConfigService()
        let sut = AppLaunchService(
            configService: mockConfigService,
            topicService: mockTopicsService,
            notificationService: MockNotificationService(),
            remoteConfigService: mockRemoteConfigService
        )
        mockConfigService._stubbedFetchAppConfigResult = .failure(.remoteJson)
        let expectedTopics = TopicResponseItem.arrangeMultiple
        mockTopicsService._stubbedFetchRemoteListResult = .success(expectedTopics)
        let result = await withCheckedContinuation { continuation in
            sut.fetch(
                completion: continuation.resume
            )
        }

        #expect(result.configResult.getError() == .remoteJson)
        #expect((try? result.topicResult.get()) == expectedTopics)
    }

    @Test
    func fetch_topicFetchFail_apiUnavailable_returnsExpectedResult() async {
        let mockConfigService = MockAppConfigService()
        let mockTopicsService = MockTopicsService()
        let mockRemoteConfigService = MockRemoteConfigService()
        let sut = AppLaunchService(
            configService: mockConfigService,
            topicService: mockTopicsService,
            notificationService: MockNotificationService(),
            remoteConfigService: mockRemoteConfigService
        )
        let expectedConfig = AppConfig.arrange
        mockConfigService._stubbedFetchAppConfigResult = .success(expectedConfig)
        mockTopicsService._stubbedFetchRemoteListResult = .failure(.apiUnavailable)
        let result = await withCheckedContinuation { continuation in
            sut.fetch(
                completion: continuation.resume
            )
        }

        #expect((try? result.configResult.get()) == expectedConfig)
        #expect(result.topicResult.getError() == .apiUnavailable)
    }

    @Test
    func fetch_triggersFetchRemoteConfig() async {
        let mockConfigService = MockAppConfigService()
        let mockTopicsService = MockTopicsService()
        let mockRemoteConfigService = MockRemoteConfigService()
        let sut = AppLaunchService(
            configService: mockConfigService,
            topicService: mockTopicsService,
            notificationService: MockNotificationService(),
            remoteConfigService: mockRemoteConfigService
        )
        
        mockConfigService._stubbedFetchAppConfigResult = .success(AppConfig.arrange)
        mockTopicsService._stubbedFetchRemoteListResult = .success(TopicResponseItem.arrangeMultiple)
        
        let _ = await withCheckedContinuation { continuation in
            sut.fetch(
                completion: continuation.resume
            )
        }
        
        #expect(mockRemoteConfigService._fetchCallCount == 1)
    }
}
