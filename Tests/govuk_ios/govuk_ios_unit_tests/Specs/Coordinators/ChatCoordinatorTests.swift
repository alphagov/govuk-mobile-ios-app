import Foundation
import UIKit
import GOVKit
import Testing

@testable import GOVKitTestUtilities
@testable import govuk_ios

@Suite
@MainActor
struct ChatCoordinatorTests {
    init() {
        UIView.setAnimationsEnabled(false)
    }

    @Test
    func start_setsChatViewController() throws {
        let mockChatService = MockChatService()
        mockChatService.setChatOnboarded()
        let mockCoordinatorBuilder = MockCoordinatorBuilder(container: .init())
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedChatController = expectedViewController
        let navigationController = UINavigationController()
        let sut = ChatCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: mockCoordinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            deepLinkStore: DeeplinkDataStore(routes: [], root: UIViewController()),
            analyticsService: MockAnalyticsService(),
            chatService: mockChatService,
            cancelOnboardingAction: { }
        )

        sut.start()
        let firstViewController = navigationController.viewControllers.first
        #expect(firstViewController == expectedViewController)
    }

    @Test
    func start_onboardingNotSeen_setsChatViewController() throws {
        let mockChatService = MockChatService()
        let mockCoordinatorBuilder = MockCoordinatorBuilder(container: .init())
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedChatController = expectedViewController
        let navigationController = UINavigationController()
        let sut = ChatCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: mockCoordinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            deepLinkStore: DeeplinkDataStore(routes: [], root: UIViewController()),
            analyticsService: MockAnalyticsService(),
            chatService: mockChatService,
            cancelOnboardingAction: { }
        )

        sut.start()
        #expect(navigationController.viewControllers.isEmpty)
    }

    @Test
    func openChatURL_showsSafariWebView() throws {
        let mockChatService = MockChatService()
        mockChatService.setChatOnboarded()
        let mockCoordinatorBuilder = MockCoordinatorBuilder(container: .init())
        let mockSafariCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedSafariCoordinator = mockSafariCoordinator

        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedChatViewController = UIViewController()
        mockViewControllerBuilder._stubbedChatController = expectedChatViewController

        let navigationController = UINavigationController()
        let sut = ChatCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: mockCoordinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            deepLinkStore: DeeplinkDataStore(routes: [], root: UIViewController()),
            analyticsService: MockAnalyticsService(),
            chatService: mockChatService,
            cancelOnboardingAction: { }
        )

        sut.start(url: nil)
        mockViewControllerBuilder._receivedChatOpenURLAction?(URL(string: "https://example.com")!)
        #expect(mockSafariCoordinator._startCalled)
    }

    @Test
    func networkUnavailable_showsInfoView() throws {
        let mockChatService = MockChatService()
        mockChatService.setChatOnboarded()
        let mockCoordinatorBuilder = MockCoordinatorBuilder(container: .init())
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedChatErrorController = expectedViewController
        let navigationController = UINavigationController()
        let sut = ChatCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: mockCoordinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            deepLinkStore: DeeplinkDataStore(routes: [], root: UIViewController()),
            analyticsService: MockAnalyticsService(),
            chatService: mockChatService,
            cancelOnboardingAction: { }
        )

        sut.start(url: nil)
        mockViewControllerBuilder._receivedHandleChatError?(ChatError.networkUnavailable)
        let firstViewController = navigationController.viewControllers.first
        #expect(firstViewController == expectedViewController)
    }

    @Test
    func handleNetworkUnavailableError_showsChatView() throws {
        let mockChatService = MockChatService()
        mockChatService.setChatOnboarded()
        let mockCoordinatorBuilder = MockCoordinatorBuilder(container: .init())
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedChatViewController = UIViewController()
        let expectedInfoViewController = UIViewController()
        mockViewControllerBuilder._stubbedChatController = expectedChatViewController
        mockViewControllerBuilder._stubbedChatErrorController = expectedInfoViewController
        let navigationController = UINavigationController()
        let sut = ChatCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: mockCoordinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            deepLinkStore: DeeplinkDataStore(routes: [], root: UIViewController()),
            analyticsService: MockAnalyticsService(),
            chatService: mockChatService,
            cancelOnboardingAction: { }
        )

        sut.start(url: nil)
        mockViewControllerBuilder._receivedHandleChatError?(ChatError.networkUnavailable)
        let firstViewController = navigationController.viewControllers.first
        #expect(firstViewController == expectedInfoViewController)
        mockViewControllerBuilder._receivedChatErrorAction?()
        let nextViewController = navigationController.viewControllers.first
        #expect(nextViewController == expectedChatViewController)
    }

    @Test
    func handleApiUnavailable_showsWebView() throws {
        let mockChatService = MockChatService()
        mockChatService.setChatOnboarded()
        let mockCoordinatorBuilder = MockCoordinatorBuilder(container: .init())
        let mockSafariCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedSafariCoordinator = mockSafariCoordinator

        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedChatViewController = UIViewController()
        let expectedInfoViewController = UIViewController()
        mockViewControllerBuilder._stubbedChatController = expectedChatViewController
        mockViewControllerBuilder._stubbedChatErrorController = expectedInfoViewController

        let navigationController = UINavigationController()
        let sut = ChatCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: mockCoordinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            deepLinkStore: DeeplinkDataStore(routes: [], root: UIViewController()),
            analyticsService: MockAnalyticsService(),
            chatService: mockChatService,
            cancelOnboardingAction: { }
        )

        sut.start(url: nil)
        mockViewControllerBuilder._receivedHandleChatError?(ChatError.apiUnavailable)
        let firstViewController = navigationController.viewControllers.first
        #expect(firstViewController == expectedInfoViewController)
        mockViewControllerBuilder._receivedChatOpenURLAction?(URL(string: "https://www.gov.uk")!)
        #expect(mockSafariCoordinator._startCalled)
    }

    @Test
    func didSelectTab_isShowingError_setsChatViewController() {
        let mockChatService = MockChatService()
        mockChatService.setChatOnboarded()
        let mockCoordinatorBuilder = MockCoordinatorBuilder(container: .init())
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedChatController = expectedViewController
        let navigationController = UINavigationController()
        let sut = ChatCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: mockCoordinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            deepLinkStore: DeeplinkDataStore(routes: [], root: UIViewController()),
            analyticsService: MockAnalyticsService(),
            chatService: mockChatService,
            cancelOnboardingAction: { }
        )
        sut.isShowingError = true

        sut.didSelectTab(1, previousTabIndex: 0)
        let firstViewController = navigationController.viewControllers.first
        #expect(firstViewController == expectedViewController)
        #expect(!sut.isShowingError)
    }
}
