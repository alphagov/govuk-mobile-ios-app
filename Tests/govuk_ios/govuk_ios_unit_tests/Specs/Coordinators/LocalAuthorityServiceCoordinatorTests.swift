import Testing
import UIKit

@testable import GOVKitTestUtilities
@testable import govuk_ios

@Suite
@MainActor
struct LocalAuthorityServiceCoordinatorTests {

    @Test
    func start_setsLocalAuthorityExplainerView() throws {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let mockAnalyticsService = MockAnalyticsService()
        let expectedViewController = UIViewController()
        let navigationController = UINavigationController()
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        mockViewControllerBuilder._stubbedLocalAuthorityExplainerViewController = expectedViewController

        let subject = LocalAuthorityServiceCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: mockViewControllerBuilder,
            analyticsService: mockAnalyticsService,
            localAuthorityService: MockLocalAuthorityService(),
            coordinatorBuilder: mockCoordinatorBuilder,
            dismissed: {}
        )
        subject.start()
        #expect(navigationController.viewControllers.first == expectedViewController)
    }

    @Test
    func dragToDismiss_callsDismissed() async {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedViewController = UIViewController()
        let navigationController = UINavigationController()
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        let mockCoordinator = MockBaseCoordinator()
        mockViewControllerBuilder._stubbedLocalAuthorityExplainerViewController = expectedViewController

        let dismissed = await withCheckedContinuation { continuation in
            let sut = LocalAuthorityServiceCoordinator(
                navigationController: navigationController,
                viewControllerBuilder: mockViewControllerBuilder,
                analyticsService: MockAnalyticsService(),
                localAuthorityService: MockLocalAuthorityService(),
                coordinatorBuilder: mockCoordinatorBuilder,
                dismissed: {
                    continuation.resume(returning: true)
                }
            )
            mockCoordinator.start(sut)
            sut.presentationControllerDidDismiss(sut.root.presentationController!)
        }
        #expect(dismissed)
    }

    @Test
    func navigateToLocalAuthority_pushesLocalAuthorityExplainerViewController() async {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedViewController = UIViewController()
        let navigationController = UINavigationController()
        let mockCoordinatorBuilder = CoordinatorBuilder.mock

        mockViewControllerBuilder._stubbedLocalAuthorityExplainerViewController = expectedViewController

        let sut = LocalAuthorityServiceCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: mockViewControllerBuilder,
            analyticsService: MockAnalyticsService(),
            localAuthorityService: MockLocalAuthorityService(),
            coordinatorBuilder: mockCoordinatorBuilder,
            dismissed: {}
        )
        sut.start()
        #expect(navigationController.viewControllers.first == expectedViewController)
    }

    @Test
    func cancelButton_callsDismissed() async {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedViewController = UIViewController()
        let mockNavigationController = MockNavigationController()
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        let mockCoordinator = MockBaseCoordinator()

        mockViewControllerBuilder._stubbedLocalAuthorityExplainerViewController = expectedViewController
        var sut: LocalAuthorityServiceCoordinator!
        let dismissed = await  withCheckedContinuation { continuation in
            sut = LocalAuthorityServiceCoordinator(
                navigationController: mockNavigationController,
                viewControllerBuilder: mockViewControllerBuilder,
                analyticsService: MockAnalyticsService(),
                localAuthorityService: MockLocalAuthorityService(),
                coordinatorBuilder: mockCoordinatorBuilder,
                dismissed: {
                    continuation.resume(returning: true)
                }
            )
            mockCoordinator.start(sut)
            mockViewControllerBuilder._receivedLocalAuthorityExplainerDismissAction?()
        }
        #expect(dismissed)
        #expect(mockCoordinator._childDidFinishReceivedChild == sut)
        #expect(sut != nil)
        #expect(mockNavigationController._dismissCalled)
        #expect(mockNavigationController._receivedDismissAnimated == true)
        }
    }
