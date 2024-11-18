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
        let expectedTopics = TopicResponseItem.arrangeMultiple
        let expectedResponse = AppLaunchResponse(
            configResult: .success(.arrange),
            topicResult: .success(expectedTopics)
        )
        var sut: LaunchCoordinator?
        let response = await withCheckedContinuation { @MainActor continuation in
            sut = LaunchCoordinator(
                navigationController: mockNavigationController,
                viewControllerBuilder: mockViewControllerBuilder,
                appLaunchService: mockAppLaunchService,
                completion: continuation.resume
            )

            sut?.start()
            mockAppLaunchService._receivedFetchCompletion?(expectedResponse)
            mockViewControllerBuilder._receivedLaunchCompletion?()
        }
        let topics = try #require(try response.topicResult.get())

        #expect(topics.count == expectedTopics.count)
        sut = nil
    }
}
