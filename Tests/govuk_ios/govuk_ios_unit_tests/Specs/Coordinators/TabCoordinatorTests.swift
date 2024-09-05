import Foundation
import XCTest

@testable import govuk_ios

class TabCoordinatorTests: XCTestCase {
    @MainActor
    func test_start_showsTabs() {
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

        XCTAssertEqual(navigationController.viewControllers.count, 1)
        let tabController = navigationController.viewControllers.first as? UITabBarController
        XCTAssertEqual(tabController?.viewControllers?.count, 2)
        let expectedCoordinators = [
            mockHomeCoordinator,
            mockSettingsCoordinator
        ]
        expectedCoordinators.forEach {
            XCTAssertTrue($0._startCalled)
        }
    }

    @MainActor
    func test_start_withKnownURL_selectsTabs() {
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

        XCTAssertEqual(tabController?.selectedIndex, 1)
        XCTAssert(mockRoute._actionCalled)
    }

    @MainActor
    func test_start_unknownURL_selectsTabs() {
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

        XCTAssertEqual(tabController?.selectedIndex, 0)
    }

    @MainActor
    func test_didSelectViewController_tracksTabEvent() {
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

        guard let tabController = navigationController.viewControllers.first as? UITabBarController
        else { return XCTFail("Unable to unpack tab controller") }

        let viewController = UIViewController()
        let expectedTitle = UUID().uuidString
        viewController.tabBarItem = .init(
            title: expectedTitle,
            image: nil,
            tag: 0
        )
        subject.tabBarController(tabController, didSelect: viewController)

        let expectedEvent = AppEvent.tabNavigation(text: expectedTitle)

        XCTAssertEqual(mockAnalyticsService._trackedEvents.count, 1)
        XCTAssertEqual(mockAnalyticsService._trackedEvents.first?.name, expectedEvent.name)
        let receivedTitle = mockAnalyticsService._trackedEvents.first?.params?["text"] as? String
        XCTAssertEqual(receivedTitle, expectedTitle)
    }

    @MainActor
    func test_didSelectViewController_noTitle_doesNothing() {
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

        guard let tabController = navigationController.viewControllers.first as? UITabBarController
        else { return XCTFail("Unable to unpack tab controller") }

        let viewController = UIViewController()
        viewController.tabBarItem = .init(
            title: nil,
            image: nil,
            tag: 0
        )
        subject.tabBarController(tabController, didSelect: viewController)

        XCTAssertEqual(mockAnalyticsService._trackedEvents.count, 0)
    }
}
