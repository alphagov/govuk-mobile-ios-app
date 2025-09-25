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
    func handlePageNotFoundError_clearsHistory_and_showsChatView() throws {
        let mockChatService = MockChatService()
        mockChatService.setChatOnboarded()
        mockChatService._clearHistoryCalled = false
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
        mockViewControllerBuilder._receivedHandleChatError?(ChatError.pageNotFound)
        let firstViewController = navigationController.viewControllers.first
        #expect(firstViewController == expectedInfoViewController)
        mockViewControllerBuilder._receivedChatErrorAction?()
        let nextViewController = navigationController.viewControllers.first
        #expect(nextViewController == expectedChatViewController)
        #expect(mockChatService._clearHistoryCalled)
    }

    @Test
    func authenticationError_retriesRequest() throws {
        let mockChatService = MockChatService()
        mockChatService.setChatOnboarded()
        let mockCoordinatorBuilder = MockCoordinatorBuilder(container: .init())
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let mockPeriAuthCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedPeriAuthCoordinator = mockPeriAuthCoordinator
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

        var didRetry = false
        mockChatService._stubbedRetryAction = { didRetry = true }
        sut.start(url: nil)
        mockViewControllerBuilder._receivedHandleChatError?(ChatError.authenticationError)
        mockCoordinatorBuilder._receivedPeriAuthCompletion?()
        #expect(didRetry)
        #expect(mockPeriAuthCoordinator._startCalled)
    }

    @Test
    func second_authenticationError_showsInfoView() throws {
        let mockChatService = MockChatService()
        mockChatService.setChatOnboarded()
        let mockCoordinatorBuilder = MockCoordinatorBuilder(container: .init())
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let mockPeriAuthCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedPeriAuthCoordinator = mockPeriAuthCoordinator

        let expectedInfoViewController = UIViewController()
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

        mockChatService._stubbedRetryAction = {
            mockChatService._stubbedIsRetryAction = true
        }
        sut.start(url: nil)
        mockViewControllerBuilder._receivedHandleChatError?(ChatError.authenticationError)
        mockCoordinatorBuilder._receivedPeriAuthCompletion?()
        #expect(mockPeriAuthCoordinator._startCalled)
        mockViewControllerBuilder._receivedHandleChatError?(ChatError.authenticationError)
        let firstViewController = navigationController.viewControllers.first
        #expect(mockChatService.isRetryAction)
        #expect(firstViewController == expectedInfoViewController)
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

    @Test
    func isEnabled_featureUnavailableOptedIn_returnsFalse() {
        let mockChatService = MockChatService()
        mockChatService._stubbedIsEnabled = false
        mockChatService.chatOptedIn = true
        let sut = ChatCoordinator(
            navigationController: UINavigationController(),
            coordinatorBuilder: MockCoordinatorBuilder(container: .init()),
            viewControllerBuilder: MockViewControllerBuilder(),
            deepLinkStore: DeeplinkDataStore(routes: [], root: UIViewController()),
            analyticsService: MockAnalyticsService(),
            chatService: mockChatService,
            cancelOnboardingAction: { }
        )

        #expect(sut.isEnabled == false)
    }

    @Test
    func isEnabled_featureAvailableOptedIn_returnsTrue() {
        let mockChatService = MockChatService()
        mockChatService._stubbedIsEnabled = true
        mockChatService.chatOptedIn = true
        let sut = ChatCoordinator(
            navigationController: UINavigationController(),
            coordinatorBuilder: MockCoordinatorBuilder(container: .init()),
            viewControllerBuilder: MockViewControllerBuilder(),
            deepLinkStore: DeeplinkDataStore(routes: [], root: UIViewController()),
            analyticsService: MockAnalyticsService(),
            chatService: mockChatService,
            cancelOnboardingAction: { }
        )

        #expect(sut.isEnabled == true)
    }

    @Test
    func isEnabled_featureAvailableOptedOut_returnsTrue() {
        let mockChatService = MockChatService()
        mockChatService._stubbedIsEnabled = true
        mockChatService.chatOptedIn = false
        let sut = ChatCoordinator(
            navigationController: UINavigationController(),
            coordinatorBuilder: MockCoordinatorBuilder(container: .init()),
            viewControllerBuilder: MockViewControllerBuilder(),
            deepLinkStore: DeeplinkDataStore(routes: [], root: UIViewController()),
            analyticsService: MockAnalyticsService(),
            chatService: mockChatService,
            cancelOnboardingAction: { }
        )

        #expect(sut.isEnabled == false)
    }
}
