import Foundation
import UIKit
import GOVKit
import Testing

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
        mockChatService.chatOnboardingSeen = true
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
            authenticationService: MockAuthenticationService(),
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
            authenticationService: MockAuthenticationService(),
            cancelOnboardingAction: { }
        )

        sut.start()
        #expect(navigationController.viewControllers.isEmpty)
    }

    @Test
    func openChatURL_showsSafariWebView() throws {
        let mockChatService = MockChatService()
        mockChatService.chatOnboardingSeen = true
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
            authenticationService: MockAuthenticationService(),
            cancelOnboardingAction: { }
        )

        sut.start(url: nil)
        mockViewControllerBuilder._receivedChatOpenURLAction?(URL(string: "https://example.com")!)
        #expect(mockSafariCoordinator._startCalled)
    }

    @Test
    func networkUnavailable_showsInfoView() throws {
        let mockChatService = MockChatService()
        mockChatService.chatOnboardingSeen = true
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
            authenticationService: MockAuthenticationService(),
            cancelOnboardingAction: { }
        )

        sut.start(url: nil)
        mockViewControllerBuilder._receivedChatHandleError?(ChatError.networkUnavailable)
        let firstViewController = navigationController.viewControllers.first
        #expect(firstViewController == expectedViewController)
    }

    @Test
    func handleNetworkUnavailableError_showsChatView() throws {
        let mockChatService = MockChatService()
        mockChatService.chatOnboardingSeen = true
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
            authenticationService: MockAuthenticationService(),
            cancelOnboardingAction: { }
        )

        sut.start(url: nil)
        mockViewControllerBuilder._receivedChatHandleError?(ChatError.networkUnavailable)
        let firstViewController = navigationController.viewControllers.first
        #expect(firstViewController == expectedInfoViewController)
        mockViewControllerBuilder._receivedChatErrorAction?()
        let nextViewController = navigationController.viewControllers.first
        #expect(nextViewController == expectedChatViewController)
    }

    @Test
    func handlePageNotFoundError_clearsHistory_and_showsChatView() throws {
        let mockChatService = MockChatService()
        mockChatService.chatOnboardingSeen = true
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
            authenticationService: MockAuthenticationService(),
            cancelOnboardingAction: { }
        )

        sut.start(url: nil)
        mockViewControllerBuilder._receivedChatHandleError?(ChatError.pageNotFound)
        let firstViewController = navigationController.viewControllers.first
        #expect(firstViewController == expectedInfoViewController)
        mockViewControllerBuilder._receivedChatErrorAction?()
        let nextViewController = navigationController.viewControllers.first
        #expect(nextViewController == expectedChatViewController)
        #expect(mockChatService._clearHistoryCalled)
    }

    @Test
    func chatViewController_handleError_authenticationError_retriesRequest() async throws {
        let mockChatService = MockChatService()
        mockChatService.chatOnboardingSeen = true
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let mockPeriAuthCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedPeriAuthCoordinator = mockPeriAuthCoordinator
        let mockAuthenticationService = MockAuthenticationService()
        let navigationController = UINavigationController()
        let sut = ChatCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: mockCoordinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            deepLinkStore: DeeplinkDataStore(routes: [], root: UIViewController()),
            analyticsService: MockAnalyticsService(),
            chatService: mockChatService,
            authenticationService: mockAuthenticationService,
            cancelOnboardingAction: { }
        )

        let didRetry = await withCheckedContinuation { continuation in
            mockChatService._stubbedRetryAction = { continuation.resume(returning: true) }
            sut.start(url: nil)
            mockAuthenticationService._stubbedTokenRefreshRequest = .success(.init(accessToken: "123", idToken: "123"))
            mockViewControllerBuilder._receivedChatHandleError?(ChatError.authenticationError)
        }
        #expect(didRetry)
    }

    @Test
    func chatViewController_handleError_secondAttempt_authenticationError_showsInfoView() throws {
        let mockChatService = MockChatService()
        mockChatService.chatOnboardingSeen = true
        let mockCoordinatorBuilder = MockCoordinatorBuilder(container: .init())
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let mockPeriAuthCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedPeriAuthCoordinator = mockPeriAuthCoordinator

        let expectedInfoViewController = UIViewController()
        mockViewControllerBuilder._stubbedChatErrorController = expectedInfoViewController

        let mockAuthenticationService = MockAuthenticationService()

        let navigationController = UINavigationController()
        let sut = ChatCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: mockCoordinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            deepLinkStore: DeeplinkDataStore(routes: [], root: UIViewController()),
            analyticsService: MockAnalyticsService(),
            chatService: mockChatService,
            authenticationService: mockAuthenticationService,
            cancelOnboardingAction: { }
        )

        mockChatService._stubbedRetryAction = {
            mockChatService._stubbedIsRetryAction = true
        }
        mockChatService._stubbedIsRetryAction = true
        sut.start(url: nil)
        mockViewControllerBuilder._receivedChatHandleError?(ChatError.authenticationError)
        let firstViewController = navigationController.viewControllers.first
        #expect(mockAuthenticationService._tokenRefreshRequestCalled == false)
        #expect(firstViewController == expectedInfoViewController)
    }


    @Test
    func didSelectTab_isShowingError_setsChatViewController() {
        let mockChatService = MockChatService()
        mockChatService.chatOnboardingSeen = true
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
            authenticationService: MockAuthenticationService(),
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
            authenticationService: MockAuthenticationService(),
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
            authenticationService: MockAuthenticationService(),
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
            authenticationService: MockAuthenticationService(),
            cancelOnboardingAction: { }
        )

        #expect(sut.isEnabled == false)
    }
}
