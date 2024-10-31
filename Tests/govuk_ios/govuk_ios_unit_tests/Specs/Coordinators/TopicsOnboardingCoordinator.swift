import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
@MainActor
struct TopicsOnboardingCoordinatorTests {

    init() {
        UIView.setAnimationsEnabled(false)
    }

    @Test
    func start_setsTopicOnboardingViewController() {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedTopicsOnboardingViewController = expectedViewController
        let navigationController = UINavigationController()

        let sut = TopicsOnboardingCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: mockViewControllerBuilder,
            analyticsService: MockAnalyticsService(),
            topicsService: MockTopicsService(),
            dismissAction: { }
        )
        sut.start()

        #expect(navigationController.viewControllers.first == expectedViewController)
    }


    @Test
    func start_hasOnboardedTopics_callsDismiss() async {
        let topicService = MockTopicsService()
        topicService._stubbedHasOnboardedTopics = true

        let dismissed = await withCheckedContinuation { continuation in

            let sut = TopicsOnboardingCoordinator(
                navigationController: UINavigationController(),
                viewControllerBuilder: MockViewControllerBuilder(),
                analyticsService: MockAnalyticsService(),
                topicsService: topicService,
                dismissAction: {
                    continuation.resume(returning: true)
                }
            )
            sut.start()
        }
        #expect(dismissed)
    }

    @Test
    func start_hasNotOnboardedTopics_doesNotCallDismiss() async throws {
        let topicService = MockTopicsService()
        topicService._stubbedHasOnboardedTopics = false

        let complete: Bool = try await withCheckedThrowingContinuation { continuation in
            let sut = TopicsOnboardingCoordinator(
                navigationController: UINavigationController(),
                viewControllerBuilder: MockViewControllerBuilder(),
                analyticsService: MockAnalyticsService(),
                topicsService: topicService,
                dismissAction: {
                    continuation.resume(with: .failure(TestError.unexpectedMethodCalled))
                }
            )
            sut.start()
            continuation.resume(returning: true)
        }
        #expect(complete)
    }
}
