import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
@MainActor
struct TopicOnboardingCoordinatorTests {

    init() {
        UIView.setAnimationsEnabled(false)
    }

    @Test
    func start_hasntOnboardingTopic_topicsExist_setsTopicOnboardingViewController() {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedTopicOnboardingViewController = expectedViewController
        let navigationController = UINavigationController()
        let mockTopicsService = MockTopicsService()
        let mockCoreDataRepository = CoreDataRepository.arrangeAndLoad
        mockTopicsService._stubbedFetchAllTopics = Topic.arrangeMultiple(
            context: mockCoreDataRepository.viewContext
        )
        mockTopicsService._stubbedHasOnboardedTopics = false
        let mockConfigService = MockAppConfigService()

        let sut = TopicOnboardingCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: mockViewControllerBuilder,
            analyticsService: MockAnalyticsService(),
            topicsService: mockTopicsService,
            configService: mockConfigService,
            dismissAction: { }
        )
        sut.start()

        #expect(navigationController.viewControllers.first == expectedViewController)
    }

    @Test
    func start_topicsDisabled_callsDismiss()async {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedTopicOnboardingViewController = expectedViewController
        let navigationController = UINavigationController()
        let mockTopicsService = MockTopicsService()
        let mockCoreDataRepository = CoreDataRepository.arrangeAndLoad
        mockTopicsService._stubbedFetchAllTopics = Topic.arrangeMultiple(
            context: mockCoreDataRepository.viewContext
        )
        mockTopicsService._stubbedHasOnboardedTopics = false
        let mockConfigService = MockAppConfigService()
        mockConfigService.features = [.search, .onboarding]

        let dismissed = await withCheckedContinuation { continuation in
            let sut = TopicOnboardingCoordinator(
                navigationController: UINavigationController(),
                viewControllerBuilder: MockViewControllerBuilder(),
                analyticsService: MockAnalyticsService(),
                topicsService: mockTopicsService,
                configService: mockConfigService,
                dismissAction: {
                    continuation.resume(returning: true)
                }
            )
            sut.start()
        }
        #expect(dismissed)
    }

    @Test
    func start_hasntOnboardingTopic_topicsEmpty_callsDismiss() async {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedTopicOnboardingViewController = expectedViewController
        let mockTopicsService = MockTopicsService()
        mockTopicsService._stubbedHasOnboardedTopics = false
        mockTopicsService._stubbedFetchAllTopics = []
        let mockConfigService = MockAppConfigService()

        let dismissed = await withCheckedContinuation { continuation in
            let sut = TopicOnboardingCoordinator(
                navigationController: UINavigationController(),
                viewControllerBuilder: MockViewControllerBuilder(),
                analyticsService: MockAnalyticsService(),
                topicsService: mockTopicsService,
                configService: mockConfigService,
                dismissAction: {
                    continuation.resume(returning: true)
                }
            )
            sut.start()
        }
        #expect(dismissed)
    }


    @Test
    func start_hasOnboardedTopics_callsDismiss() async {
        let mockTopicsService = MockTopicsService()
        mockTopicsService._stubbedHasOnboardedTopics = true
        let mockConfigService = MockAppConfigService()

        let dismissed = await withCheckedContinuation { continuation in
            let sut = TopicOnboardingCoordinator(
                navigationController: UINavigationController(),
                viewControllerBuilder: MockViewControllerBuilder(),
                analyticsService: MockAnalyticsService(),
                topicsService: mockTopicsService,
                configService: mockConfigService,
                dismissAction: {
                    continuation.resume(returning: true)
                }
            )
            sut.start()
        }
        #expect(dismissed)
    }

    @Test
    func start_hasNotOnboardedTopics_setsTopicOnboarding() async throws {
        let mockTopicService = MockTopicsService()
        mockTopicService._stubbedHasOnboardedTopics = false
        let mockCoreDataRepository = CoreDataRepository.arrangeAndLoad
        mockTopicService._stubbedFetchAllTopics = Topic.arrangeMultiple(
            context: mockCoreDataRepository.viewContext
        )
        let mockConfigService = MockAppConfigService()
        let complete: Bool = try await withCheckedThrowingContinuation { continuation in
            let sut = TopicOnboardingCoordinator(
                navigationController: UINavigationController(),
                viewControllerBuilder: MockViewControllerBuilder(),
                analyticsService: MockAnalyticsService(),
                topicsService: mockTopicService,
                configService: mockConfigService,
                dismissAction: {
                    continuation.resume(with: .failure(TestError.unexpectedMethodCalled))
                }
            )
            sut.start()
            continuation.resume(returning: true)
        }
        #expect(complete)
    }

    @Test
    func start_topicOnboardingDismiss_setsHasOnboardedTopics() async throws {
        let mockNavigationController = MockNavigationController()
        let mockTopicService = MockTopicsService()
        mockTopicService._stubbedHasOnboardedTopics = false
        let mockCoreDataRepository = CoreDataRepository.arrangeAndLoad
        mockTopicService._stubbedFetchAllTopics = Topic.arrangeMultiple(
            context: mockCoreDataRepository.viewContext
        )
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedTopicOnboardingViewController = expectedViewController
        let mockConfigService = MockAppConfigService()
        let dismissed: Bool = try await withCheckedThrowingContinuation { continuation in
            let sut = TopicOnboardingCoordinator(
                navigationController: mockNavigationController,
                viewControllerBuilder: mockViewControllerBuilder,
                analyticsService: MockAnalyticsService(),
                topicsService: mockTopicService,
                configService: mockConfigService,
                dismissAction: {
                    continuation.resume(returning: true)
                }
            )
            sut.start()
            mockViewControllerBuilder._receivedTopicOnboardingDismissAction?()
        }
        #expect(dismissed)
        #expect(mockNavigationController._setViewControllers == [expectedViewController])
        #expect(mockTopicService._setHasOnboardedTopicsCalled)
    }
}
