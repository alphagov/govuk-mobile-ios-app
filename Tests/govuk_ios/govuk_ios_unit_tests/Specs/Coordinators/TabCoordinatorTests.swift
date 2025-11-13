import Foundation
import UIKit
import Testing
import GOVKit

@testable import govuk_ios

@Suite
@MainActor
struct TabCoordinatorTests {
    @Test
    func start_showsTabs() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock

        let mockHomeCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedHomeCoordinator = mockHomeCoordinator

        let mockChatCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedChatCoordinator = mockChatCoordinator

        let mockSettingsCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedSettingsCoordinator = mockSettingsCoordinator

        let navigationController = UINavigationController()
        let subject = TabCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            navigationController: navigationController,
            analyticsService: MockAnalyticsService()
        )

        subject.start()

        #expect(navigationController.viewControllers.count == 1)
        let tabController = navigationController.viewControllers.first as? UITabBarController
        #expect(tabController?.viewControllers?.count == 3)
        let expectedCoordinators = [
            mockHomeCoordinator,
            mockChatCoordinator,
            mockSettingsCoordinator
        ]
        expectedCoordinators.forEach {
            #expect($0._startCalled)
        }
    }

    @Test
    func start_withKnownURL_selectsTabs() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockAnalyticsService = MockAnalyticsService()

        let mockHomeCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedHomeCoordinator = mockHomeCoordinator

        let mockChatCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedChatCoordinator = mockChatCoordinator

        let mockSettingsCoordinator = MockBaseCoordinator()
        let mockRoute = MockDeeplinkRoute(pattern: "/test")
        mockSettingsCoordinator._stubbedRoute = .mock(
            parent: mockSettingsCoordinator,
            route: mockRoute
        )
        mockCoordinatorBuilder._stubbedSettingsCoordinator = mockSettingsCoordinator

        let navigationController = UINavigationController()
        let subject = TabCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            navigationController: navigationController,
            analyticsService: mockAnalyticsService
        )

        let url = URL(string: "govuk://gov.uk/test")
        subject.start(url: url)
        let tabController = navigationController.viewControllers.first as? UITabBarController

        #expect(tabController?.selectedIndex == 2)
        #expect(mockRoute._actionCalled)

        #expect(mockAnalyticsService._trackedEvents.count == 1)
        let trackedEvent = mockAnalyticsService._trackedEvents[0]

        #expect(trackedEvent.name == "Navigation")
        let receivedType = trackedEvent.params?["type"] as? String
        #expect(receivedType == "DeepLink")
        let receivedUrl = trackedEvent.params?["url"] as? String
        #expect(receivedUrl == url?.absoluteString)
        let receivedTitle = trackedEvent.params?["text"] as? String
        #expect(receivedTitle == "Opened")
    }

    @Test
    func start_unknownURL_selectsTabs() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock

        let mockHomeCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedHomeCoordinator = mockHomeCoordinator

        let mockSettingsCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedSettingsCoordinator = mockSettingsCoordinator

        let navigationController = UINavigationController()
        let subject = TabCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            navigationController: navigationController,
            analyticsService: MockAnalyticsService()
        )

        let url = URL(string: "govuk://gov.uk/unknown")
        subject.start(url: url)
        let tabController = navigationController.viewControllers.first as? UITabBarController

        #expect(tabController?.selectedIndex == 0)
    }

    @Test
    func didSelectViewController_tracksTabEvent() throws {
        let mockAnalyticsService = MockAnalyticsService()
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock

        let mockHomeCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedHomeCoordinator = mockHomeCoordinator

        let mockSettingsCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedSettingsCoordinator = mockSettingsCoordinator

        let navigationController = UINavigationController()
        let subject = TabCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            navigationController: navigationController,
            analyticsService: mockAnalyticsService
        )

        let url = URL(string: "govuk://gov.uk/unknown")
        subject.start(url: url)

        let tabController = try #require(navigationController.viewControllers.first as? UITabBarController)

        let viewController = UIViewController()
        let expectedTitle = UUID().uuidString
        viewController.tabBarItem = .init(
            title: expectedTitle,
            image: nil,
            tag: 0
        )
        subject.tabBarController(tabController, didSelect: viewController)

        let expectedEvent = AppEvent.tabNavigation(text: expectedTitle)

        #expect(mockAnalyticsService._trackedEvents.count == 2)
        let trackedEvent1 = mockAnalyticsService._trackedEvents[0]
        let trackedEvent2 = mockAnalyticsService._trackedEvents[1]

        #expect(trackedEvent1.name == expectedEvent.name)
        #expect(trackedEvent2.name == expectedEvent.name)
        let receivedType1 = trackedEvent1.params?["type"] as? String
        #expect(receivedType1 == "DeepLink")
        let receivedType2 = trackedEvent2.params?["type"] as? String
        #expect(receivedType2 == "Tab")
        let receivedUrl = trackedEvent1.params?["url"] as? String
        #expect(receivedUrl == url?.absoluteString)
        let receivedTitle1 = trackedEvent1.params?["text"] as? String
        #expect(receivedTitle1 == "Failed")
        let receivedTitle2 = trackedEvent2.params?["text"] as? String
        #expect(receivedTitle2 == expectedTitle)
    }

    @Test
    func didSelectViewController_noTitle_doesNothing() throws {
        let mockAnalyticsService = MockAnalyticsService()
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock

        let mockHomeCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedHomeCoordinator = mockHomeCoordinator

        let mockSettingsCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedSettingsCoordinator = mockSettingsCoordinator

        let navigationController = UINavigationController()
        let subject = TabCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            navigationController: navigationController,
            analyticsService: mockAnalyticsService
        )

        let url = URL(string: "govuk://gov.uk/unknown")
        subject.start(url: url)

        let tabController = try #require(navigationController.viewControllers.first as? UITabBarController)

        let viewController = UIViewController()
        viewController.tabBarItem = .init(
            title: nil,
            image: nil,
            tag: 0
        )
        subject.tabBarController(tabController, didSelect: viewController)

        #expect(mockAnalyticsService._trackedEvents.count == 1)
        let trackedEvent = mockAnalyticsService._trackedEvents[0]

        #expect(trackedEvent.name == "Navigation")
        let receivedType = trackedEvent.params?["type"] as? String
        #expect(receivedType == "DeepLink")
        let receivedUrl = trackedEvent.params?["url"] as? String
        #expect(receivedUrl == url?.absoluteString)
        let receivedTitle = trackedEvent.params?["text"] as? String
        #expect(receivedTitle == "Failed")
    }

    @Test(arguments: zip(
        [0,1],
        [true, false]
    ))
    func selectingTab_doesCall_didselectTab_asNeeded(selectedIndex: Int,
                                                     didReselectTab: Bool) throws {
        let mockAnalyticsService = MockAnalyticsService()
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock

        let mockHomeCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedHomeCoordinator = mockHomeCoordinator

        let mockChatCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedChatCoordinator = mockChatCoordinator

        let mockSettingsCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedSettingsCoordinator = mockSettingsCoordinator

        let navigationController = UINavigationController()
        let subject = TabCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            navigationController: navigationController,
            analyticsService: mockAnalyticsService
        )

        let url = URL(string: "govuk://gov.uk/unknown")
        subject.start(url: url)

        let tabController = try #require(navigationController.viewControllers.first as? UITabBarController)
        tabController.selectedIndex = selectedIndex
        var startingCoordinator: MockBaseCoordinator?
        switch selectedIndex {
            case 0:
            startingCoordinator = mockHomeCoordinator
        case 1:
            startingCoordinator = mockChatCoordinator
        case 2:
            startingCoordinator = mockSettingsCoordinator
        default:
            Issue.record("selectedIndex \(selectedIndex) is out of bounds")
        }

        let viewController = UIViewController()
        viewController.tabBarItem = .init(
            title: "test_title",
            image: nil,
            tag: 0
        )
        subject.tabBarController(tabController, didSelect: viewController)
        let tabReselected = (startingCoordinator?._selectedTab == startingCoordinator?._previousTab)
        #expect(tabReselected == didReselectTab)
    }

    @Test
    func finishingSettingsTab_finishesTabCoordinator() throws {
        let mockAnalyticsService = MockAnalyticsService()
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock

        let mockHomeCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedHomeCoordinator = mockHomeCoordinator
        let mockAuthenticationService = MockAuthenticationService()
        mockAuthenticationService._stubbedIsSignedIn = false

        let mockChatCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedChatCoordinator = mockChatCoordinator

        let settingsCoordinator = SettingsCoordinator(
            navigationController: MockNavigationController(),
            viewControllerBuilder: MockViewControllerBuilder(),
            deeplinkStore: DeeplinkDataStore(routes: [], root: UIViewController()),
            analyticsService: MockAnalyticsService(),
            coordinatorBuilder: mockCoordinatorBuilder,
            deviceInformationProvider: MockDeviceInformationProvider(),
            authenticationService: mockAuthenticationService,
            notificationService: MockNotificationService(),
            localAuthenticationService: MockLocalAuthenticationService()
        )
        mockCoordinatorBuilder._stubbedSettingsCoordinator = settingsCoordinator

        let navigationController = UINavigationController()
        let subject = TabCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            navigationController: navigationController,
            analyticsService: mockAnalyticsService
        )

        subject.start(url: nil)
        #expect(subject.childCoordinators.count == 3)
        settingsCoordinator.finish()
        #expect(subject.childCoordinators.count == 2)
    }
}
