import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
@MainActor
struct TabCoordinatorTests {
    @Test
    func start_showsTabs() {
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

        subject.start()

        #expect(navigationController.viewControllers.count == 1)
        let tabController = navigationController.viewControllers.first as? UITabBarController
        #expect(tabController?.viewControllers?.count == 2)
        let expectedCoordinators = [
            mockHomeCoordinator,
            mockSettingsCoordinator
        ]
        expectedCoordinators.forEach {
            #expect($0._startCalled)
        }
    }

    @Test
    func start_withKnownURL_selectsTabs() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock

        let mockHomeCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedHomeCoordinator = mockHomeCoordinator

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
            analyticsService: MockAnalyticsService()
        )

        let url = URL(string: "govuk://gov.uk/test")
        subject.start(url: url)
        let tabController = navigationController.viewControllers.first as? UITabBarController

        #expect(tabController?.selectedIndex == 1)
        #expect(mockRoute._actionCalled)
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

        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(mockAnalyticsService._trackedEvents.first?.name == expectedEvent.name)
        let receivedTitle = mockAnalyticsService._trackedEvents.first?.params?["text"] as? String
        #expect(receivedTitle == expectedTitle)
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

        #expect(mockAnalyticsService._trackedEvents.count == 0)
    }

    @Test(arguments: zip(
        [0,1],
        [true, false]
    ))
    func selectingTab_doesCall_didReselectTab_asNeeded(selectedIndex: Int,
                                                       didReselectTab: Bool) async throws {
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
        tabController.selectedIndex = selectedIndex

        let viewController = UIViewController()
        viewController.tabBarItem = .init(
            title: "test_title",
            image: nil,
            tag: 0
        )
        subject.tabBarController(tabController, didSelect: viewController)

        #expect(mockHomeCoordinator._didReselectTab == didReselectTab)
    }
}
