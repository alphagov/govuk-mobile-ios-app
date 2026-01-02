import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
struct LaunchCoordinatorTests {
    @Test
    @MainActor
    func start_launchCompletion_callsCompletion() async throws {
        let mockNavigationController = UINavigationController()
        let mockViewControllerBuilder = ViewControllerBuilder.mock
        let mockAppLaunchService = MockAppLaunchService()
        let mockAnalytics = MockAnalyticsService()
        let expectedTopics = TopicResponseItem.arrangeMultiple
        let expectedResponse = AppLaunchResponse(
            configResult: .success(.arrange),
            topicResult: .success(expectedTopics),
            notificationConsentResult: .aligned,
            remoteConfigFetchResult: .success,
            appVersionProvider: MockAppVersionProvider()
        )
        var sut: LaunchCoordinator?
        let response = await withCheckedContinuation { @MainActor continuation in
            sut = LaunchCoordinator(
                navigationController: mockNavigationController,
                viewControllerBuilder: mockViewControllerBuilder,
                appLaunchService: mockAppLaunchService,
                anayticsService: mockAnalytics,
                completion: continuation.resume
            )

            sut?.start()
            mockAppLaunchService._receivedFetchCompletion?(expectedResponse)
            mockViewControllerBuilder._receivedLaunchCompletion?()
        }
        let topics = try response.topicResult.get()

        #expect(topics.count == expectedTopics.count)

        // Retain the subject until test is complete
        sut = nil
    }
}
