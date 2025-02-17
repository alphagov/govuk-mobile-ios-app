import Foundation
import UIKit
import Testing
import GOVKit
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
            topicsService: MockTopicsService(),
            deviceInformationProvider: MockDeviceInformationProvider()
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
            topicsService: MockTopicsService(),
            deviceInformationProvider: MockDeviceInformationProvider()
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
            topicsService: MockTopicsService(),
            deviceInformationProvider: MockDeviceInformationProvider()
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
            topicsService: MockTopicsService(),
            deviceInformationProvider: MockDeviceInformationProvider()
        )
        subject.start()

        let coreData = CoreDataRepository.arrange
        let topic = Topic(context: coreData.viewContext)
        topic.ref = "123"
        topic.title = "test_title"
        mockViewControllerBuilder._receivedTopicWidgetViewModel?.topicAction(topic)

        let navigationEvent = mockAnalyticsService._trackedEvents.first

        #expect(navigationEvent?.params?["text"] as? String == "test_title")
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
            topicsService: MockTopicsService(),
            deviceInformationProvider: MockDeviceInformationProvider()
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
            topicsService: MockTopicsService(),
            deviceInformationProvider: MockDeviceInformationProvider()
        )
        subject.start()

        mockViewControllerBuilder._receivedTopicWidgetViewModel?.allTopicsAction()

        let navigationEvent = mockAnalyticsService._trackedEvents.first

        #expect(navigationEvent?.params?["text"] as? String == "See all topics")
        #expect(navigationEvent?.params?["type"] as? String == "Widget")
        #expect(navigationEvent?.name == "Navigation")
    }
    
    @Test
    @MainActor
    func didReselectTab_scrollsToTop_whenOnHomeScreen() {
        let mockCoodinatorBuilder = MockCoordinatorBuilder(container: .init())
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let navigationController = UINavigationController()
        
        let homeViewController = MockHomeViewController()
        mockViewControllerBuilder._stubbedHomeViewController = homeViewController
        
        let subject = HomeCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: mockCoodinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            deeplinkStore: DeeplinkDataStore(routes: []),
            analyticsService: MockAnalyticsService(),
            configService: MockAppConfigService(),
            topicsService: MockTopicsService(),
            deviceInformationProvider: MockDeviceInformationProvider()
        )
        
        subject.start()
        subject.didReselectTab()
        
        #expect(homeViewController._didScrollToTop)
    }
    
    @Test
    @MainActor
    func didReselectTab_doesNotScrollsToTop_whenOnChildScreen() {
        let mockCoodinatorBuilder = MockCoordinatorBuilder(container: .init())
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let navigationController = UINavigationController()
        
        let homeViewController = MockHomeViewController()
        mockViewControllerBuilder._stubbedHomeViewController = homeViewController
        
        let subject = HomeCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: mockCoodinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            deeplinkStore: DeeplinkDataStore(routes: []),
            analyticsService: MockAnalyticsService(),
            configService: MockAppConfigService(),
            topicsService: MockTopicsService(),
            deviceInformationProvider: MockDeviceInformationProvider()
        )
        
        subject.start()
        subject.start(MockBaseCoordinator())
        subject.didReselectTab()
        
        #expect(homeViewController._didScrollToTop == false)
    }
}
