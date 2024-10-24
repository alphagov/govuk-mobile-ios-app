import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
@MainActor
struct HomeCoordinatorTests {
    init() {
        UIView.setAnimationsEnabled(false)
    }

    @Test
    @MainActor
    func start_setsHomeViewController() {
        let mockCoodinatorBuilder = MockCoordinatorBuilder(container: .init())
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedHomeViewController = expectedViewController
        let navigationController = UINavigationController()
        let subject = HomeCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: mockCoodinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            deeplinkStore: DeeplinkDataStore(routes: []),
            analyticsService: MockAnalyticsService(),
            configService: MockAppConfigService(),
            topicsService: MockTopicsService()
        )
        subject.start()

        #expect(navigationController.viewControllers.first == expectedViewController)
    }

    @Test
    @MainActor
    func startRecentActivity_startsCoordinatorAndTrackEvent() {
        let mockCoodinatorBuilder = MockCoordinatorBuilder(container: .init())
        let mockViewControllerBuilder = MockViewControllerBuilder()
        mockViewControllerBuilder._stubbedHomeViewController = UIViewController()
        let mockAnalyticsService = MockAnalyticsService()
        let navigationController = UINavigationController()
        let subject = HomeCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: mockCoodinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            deeplinkStore: DeeplinkDataStore(routes: []),
            analyticsService: mockAnalyticsService,
            configService: MockAppConfigService(),
            topicsService: MockTopicsService()
        )
        subject.start()

        mockViewControllerBuilder._receivedHomeRecentActivityAction?()

        let navigationEvent = mockAnalyticsService._trackedEvents.first

        #expect(navigationEvent?.params?["text"] as? String == "Pages you’ve visited")
        #expect(navigationEvent?.params?["type"] as? String == "Widget")
        #expect(navigationEvent?.name == "Navigation")
    }

    @Test
    @MainActor
    func searchAction_startsCoordinatorAndTracksEvent() {
        let mockCoodinatorBuilder = MockCoordinatorBuilder(container: .init())
        let mockViewControllerBuilder = MockViewControllerBuilder()
        mockViewControllerBuilder._stubbedHomeViewController = UIViewController()
        let mockAnalyticsService = MockAnalyticsService()
        let navigationController = UINavigationController()
        let subject = HomeCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: mockCoodinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            deeplinkStore: DeeplinkDataStore(routes: []),
            analyticsService: mockAnalyticsService,
            configService: MockAppConfigService(),
            topicsService: MockTopicsService()
        )
        subject.start()

        mockViewControllerBuilder._receivedHomeSearchAction?()

        let navigationEvent = mockAnalyticsService._trackedEvents.first

        #expect(navigationEvent?.params?["text"] as? String == "Search")
        #expect(navigationEvent?.params?["type"] as? String == "Widget")
        #expect(navigationEvent?.name == "Navigation")
    }

    @Test
    @MainActor
    func topicAction_startsCoordinatorAndTracksEvent() {
        let mockCoodinatorBuilder = MockCoordinatorBuilder(container: .init())
        let mockViewControllerBuilder = MockViewControllerBuilder()
        mockViewControllerBuilder._stubbedHomeViewController = UIViewController()
        let mockAnalyticsService = MockAnalyticsService()
        let navigationController = UINavigationController()
        let subject = HomeCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: mockCoodinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            deeplinkStore: DeeplinkDataStore(routes: []),
            analyticsService: mockAnalyticsService,
            configService: MockAppConfigService(),
            topicsService: MockTopicsService()
        )
        subject.start()

        let coreData = CoreDataRepository.arrange
        let topic = Topic(context: coreData.viewContext)
        topic.ref = "123"
        mockViewControllerBuilder._receivedTopicWidgetViewModel?.topicAction(topic)

        let navigationEvent = mockAnalyticsService._trackedEvents.first

        #expect(navigationEvent?.params?["text"] as? String == "123")
        #expect(navigationEvent?.params?["type"] as? String == "Widget")
        #expect(navigationEvent?.name == "Navigation")
    }

    @Test
    @MainActor
    func editTopicAction_startsCoordinatorAndTracksEvent() {
        let mockCoodinatorBuilder = MockCoordinatorBuilder(container: .init())
        let mockViewControllerBuilder = MockViewControllerBuilder()
        mockViewControllerBuilder._stubbedHomeViewController = UIViewController()
        let mockAnalyticsService = MockAnalyticsService()
        let navigationController = UINavigationController()
        let subject = HomeCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: mockCoodinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            deeplinkStore: DeeplinkDataStore(routes: []),
            analyticsService: mockAnalyticsService,
            configService: MockAppConfigService(),
            topicsService: MockTopicsService()
        )
        subject.start()

        mockViewControllerBuilder._receivedTopicWidgetViewModel?.editAction()

        let navigationEvent = mockAnalyticsService._trackedEvents.first

        #expect(navigationEvent?.params?["text"] as? String == "EditTopics")
        #expect(navigationEvent?.params?["type"] as? String == "Widget")
        #expect(navigationEvent?.name == "Navigation")
    }

    @Test
    @MainActor
    func allTopicAction_startsCoordinatorAndTracksEvent() {
        let mockCoodinatorBuilder = MockCoordinatorBuilder(container: .init())
        let mockViewControllerBuilder = MockViewControllerBuilder()
        mockViewControllerBuilder._stubbedHomeViewController = UIViewController()
        let mockAnalyticsService = MockAnalyticsService()
        let navigationController = UINavigationController()
        let subject = HomeCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: mockCoodinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            deeplinkStore: DeeplinkDataStore(routes: []),
            analyticsService: mockAnalyticsService,
            configService: MockAppConfigService(),
            topicsService: MockTopicsService()
        )
        subject.start()

        mockViewControllerBuilder._receivedTopicWidgetViewModel?.allTopicsAction()

        let navigationEvent = mockAnalyticsService._trackedEvents.first

        #expect(navigationEvent?.params?["text"] as? String == "See all topics")
        #expect(navigationEvent?.params?["type"] as? String == "Widget")
        #expect(navigationEvent?.name == "Navigation")
    }
}
