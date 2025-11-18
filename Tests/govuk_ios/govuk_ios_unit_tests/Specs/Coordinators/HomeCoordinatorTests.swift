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
        let mockCoodinatorBuilder = MockCoordinatorBuilder.mock
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedHomeViewController = expectedViewController
        let navigationController = UINavigationController()
        let subject = HomeCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: mockCoodinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            deeplinkStore: DeeplinkDataStore(routes: [], root: UIViewController()),
            analyticsService: MockAnalyticsService(),
            configService: MockAppConfigService(),
            topicsService: MockTopicsService(),
            notificationService: MockNotificationService(),
            deviceInformationProvider: MockDeviceInformationProvider(),
            searchService: MockSearchService(),
            activityService: MockActivityService(),
            localAuthorityService: MockLocalAuthorityService(),
            userDefaultsService: MockUserDefaultsService(),
            chatService: MockChatService()
        )
        subject.start()

        #expect(navigationController.viewControllers.first == expectedViewController)
    }

    @Test
    @MainActor
    func startRecentActivity_startsCoordinatorAndTrackEvent() {
        let mockCoodinatorBuilder = MockCoordinatorBuilder.mock
        let mockViewControllerBuilder = MockViewControllerBuilder()
        mockViewControllerBuilder._stubbedHomeViewController = UIViewController()
        let mockAnalyticsService = MockAnalyticsService()
        let navigationController = UINavigationController()
        let subject = HomeCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: mockCoodinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            deeplinkStore: DeeplinkDataStore(routes: [], root: UIViewController()),
            analyticsService: mockAnalyticsService,
            configService: MockAppConfigService(),
            topicsService: MockTopicsService(),
            notificationService: MockNotificationService(),
            deviceInformationProvider: MockDeviceInformationProvider(),
            searchService: MockSearchService(),
            activityService: MockActivityService(),
            localAuthorityService: MockLocalAuthorityService(),
            userDefaultsService: MockUserDefaultsService(),
            chatService: MockChatService()
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
    func startEditLocalAuthority_startsCoordinatorAndTrackEvent() {
        let mockCoodinatorBuilder = MockCoordinatorBuilder.mock
        let mockViewControllerBuilder = MockViewControllerBuilder()
        mockViewControllerBuilder._stubbedHomeViewController = UIViewController()
        let mockAnalyticsService = MockAnalyticsService()
        let navigationController = UINavigationController()
        let subject = HomeCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: mockCoodinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            deeplinkStore: DeeplinkDataStore(routes: [], root: UIViewController()),
            analyticsService: mockAnalyticsService,
            configService: MockAppConfigService(),
            topicsService: MockTopicsService(),
            notificationService: MockNotificationService(),
            deviceInformationProvider: MockDeviceInformationProvider(),
            searchService: MockSearchService(),
            activityService: MockActivityService(),
            localAuthorityService: MockLocalAuthorityService(),
            userDefaultsService: MockUserDefaultsService(),
            chatService: MockChatService()
        )
        subject.start()

        mockViewControllerBuilder._receivedEditLocalAuthorityAction?()

        let navigationEvent = mockAnalyticsService._trackedEvents.first

        #expect(navigationEvent?.params?["text"] as? String == "Edit your local services")
        #expect(navigationEvent?.params?["type"] as? String == "Widget")
        #expect(navigationEvent?.name == "Navigation")
    }

    @Test
    @MainActor
    func topicAction_startsCoordinatorAndTracksEvent() {
        let mockCoodinatorBuilder = MockCoordinatorBuilder.mock
        let mockViewControllerBuilder = MockViewControllerBuilder()
        mockViewControllerBuilder._stubbedHomeViewController = UIViewController()
        let mockAnalyticsService = MockAnalyticsService()
        let navigationController = UINavigationController()
        let subject = HomeCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: mockCoodinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            deeplinkStore: DeeplinkDataStore(routes: [], root: UIViewController()),
            analyticsService: mockAnalyticsService,
            configService: MockAppConfigService(),
            topicsService: MockTopicsService(),
            notificationService: MockNotificationService(),
            deviceInformationProvider: MockDeviceInformationProvider(),
            searchService: MockSearchService(),
            activityService: MockActivityService(),
            localAuthorityService: MockLocalAuthorityService(),
            userDefaultsService: MockUserDefaultsService(),
            chatService: MockChatService()
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
    func didReselectTab_resetsToDefaultState_whenOnHomeScreen() {
        let mockCoodinatorBuilder = MockCoordinatorBuilder.mock
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let navigationController = UINavigationController()

        let homeViewController = MockHomeViewController()
        mockViewControllerBuilder._stubbedHomeViewController = homeViewController

        let subject = HomeCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: mockCoodinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            deeplinkStore: DeeplinkDataStore(routes: [], root: UIViewController()),
            analyticsService: MockAnalyticsService(),
            configService: MockAppConfigService(),
            topicsService: MockTopicsService(),
            notificationService: MockNotificationService(),
            deviceInformationProvider: MockDeviceInformationProvider(),
            searchService: MockSearchService(),
            activityService: MockActivityService(),
            localAuthorityService: MockLocalAuthorityService(),
            userDefaultsService: MockUserDefaultsService(),
            chatService: MockChatService()
        )

        subject.start()
        subject.didSelectTab(0, previousTabIndex: 0)

        #expect(homeViewController._hasResetState)
    }

    @Test
    @MainActor
    func didReselectTab_doesNotResetToDefaultState_whenOnChildScreen() {
        let mockCoodinatorBuilder = MockCoordinatorBuilder.mock
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let navigationController = UINavigationController()

        let homeViewController = MockHomeViewController()
        mockViewControllerBuilder._stubbedHomeViewController = homeViewController

        let subject = HomeCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: mockCoodinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            deeplinkStore: DeeplinkDataStore(routes: [], root: UIViewController()),
            analyticsService: MockAnalyticsService(),
            configService: MockAppConfigService(),
            topicsService: MockTopicsService(),
            notificationService: MockNotificationService(),
            deviceInformationProvider: MockDeviceInformationProvider(),
            searchService: MockSearchService(),
            activityService: MockActivityService(),
            localAuthorityService: MockLocalAuthorityService(),
            userDefaultsService: MockUserDefaultsService(),
            chatService: MockChatService()
        )

        subject.start()
        subject.start(MockBaseCoordinator())
        subject.didSelectTab(0, previousTabIndex: 0)

        #expect(homeViewController._hasResetState == false)
    }

    @Test
    @MainActor
    func openSearchAction_oresentsWebView() {
        let mockCoodinatorBuilder = MockCoordinatorBuilder.mock
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let navigationController = UINavigationController()

        let homeViewController = MockHomeViewController()
        mockViewControllerBuilder._stubbedHomeViewController = homeViewController

        let subject = HomeCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: mockCoodinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            deeplinkStore: DeeplinkDataStore(routes: [], root: UIViewController()),
            analyticsService: MockAnalyticsService(),
            configService: MockAppConfigService(),
            topicsService: MockTopicsService(),
            notificationService: MockNotificationService(),
            deviceInformationProvider: MockDeviceInformationProvider(),
            searchService: MockSearchService(),
            activityService: MockActivityService(),
            localAuthorityService: MockLocalAuthorityService(),
            userDefaultsService: MockUserDefaultsService(),
            chatService: MockChatService()
        )

        let mockSafariCoordinator = MockBaseCoordinator()
        mockCoodinatorBuilder._stubbedSafariCoordinator = mockSafariCoordinator

        subject.start()
        let expectedSearchItem = SearchItem.arrange
        mockViewControllerBuilder._receivedHomeSearchAction?(expectedSearchItem)

        #expect(mockSafariCoordinator._startCalled)
        #expect(mockCoodinatorBuilder._receivedSafariCoordinatorURL == expectedSearchItem.link)
    }
}
