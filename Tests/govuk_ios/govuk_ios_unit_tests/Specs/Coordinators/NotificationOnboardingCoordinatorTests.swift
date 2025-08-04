import Foundation
import Testing
import UIKit

@testable import GOVKitTestUtilities
@testable import govuk_ios

@Suite
class NotificationOnboardingCoordinatorTests {
    @Test
    @MainActor
    func start_shouldRequestPermission_startsOnboarding() async {
        let mockNotificationService = MockNotificationService()
        let mockNavigationController = MockNavigationController()
        let mockViewControllerBuilder = MockViewControllerBuilder.mock
        let mockNotificationOnboardingService = MockNotificationsOnboardingService()
        mockNotificationOnboardingService.hasSeenNotificationsOnboarding = false
        mockNotificationService._stubbedShouldRequestPermission = true
        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedNotificationOnboardingViewController = expectedViewController
        await withCheckedContinuation { continuation in
            let sut = NotificationOnboardingCoordinator(
                navigationController: mockNavigationController,
                notificationService: mockNotificationService,
                notificationOnboardingService: mockNotificationOnboardingService,
                analyticsService: MockAnalyticsService(),
                viewControllerBuilder: mockViewControllerBuilder,
                coordinatorBuilder: MockCoordinatorBuilder.mock,
                completion: { }
            )
            mockNotificationService._stubbedShouldRequestPermission = true
            mockNavigationController._setViewControllersCalledAction = {
                continuation.resume()
            }
            sut.start(url: nil)
        }
        #expect(mockNavigationController._setViewControllers?.first == expectedViewController)
    }

    @Test
    @MainActor
    func start_shouldRequestPermissionFalse_completesCoordinator() async {
        let mockNotificationService = MockNotificationService()
        let mockNavigationController = MockNavigationController()
        let mockNotificationOnboardingService = MockNotificationsOnboardingService()
        mockNotificationService._stubbedShouldRequestPermission = false
        let completed = await withCheckedContinuation { continuation in
            let sut = NotificationOnboardingCoordinator(
                navigationController: mockNavigationController,
                notificationService: mockNotificationService,
                notificationOnboardingService: mockNotificationOnboardingService,
                analyticsService: MockAnalyticsService(),
                viewControllerBuilder: MockViewControllerBuilder(),
                coordinatorBuilder: MockCoordinatorBuilder.mock,
                completion: {
                    continuation.resume(returning: true)
                }
            )
            sut.start(url: nil)
        }
        #expect(completed)
        #expect(mockNavigationController._setViewControllers == nil)
    }

    @Test
    @MainActor
    func start_whenPermissionNotRequiredAndOnboardingNotSeen_completesImmediately() async {
        let mockNotificationService = MockNotificationService()
        let mockNavigationController = MockNavigationController()
        let mockNotificationOnboardingService = MockNotificationsOnboardingService()
        mockNotificationService._stubbedShouldRequestPermission = false
        let completed = await withCheckedContinuation { continuation in
            let sut = NotificationOnboardingCoordinator(
                navigationController: mockNavigationController,
                notificationService: mockNotificationService,
                notificationOnboardingService: mockNotificationOnboardingService,
                analyticsService: MockAnalyticsService(),
                viewControllerBuilder: MockViewControllerBuilder(),
                coordinatorBuilder: MockCoordinatorBuilder.mock,
                completion: {
                    continuation.resume(returning: true)
                }
            )
            sut.start(url: nil)
        }
        #expect(completed)
        #expect(mockNavigationController._setViewControllers == nil)
    }

    @Test
    @MainActor
    func start_whenPermissionNotRequiredAndOnboardingSeen_completesImmediately() async {
        let mockNotificationService = MockNotificationService()
        let mockNavigationController = MockNavigationController()
        let mockNotificationOnboardingService = MockNotificationsOnboardingService()
        mockNotificationService._stubbedShouldRequestPermission = false
        let completed = await withCheckedContinuation { continuation in
            let sut = NotificationOnboardingCoordinator(
                navigationController: mockNavigationController,
                notificationService: mockNotificationService,
                notificationOnboardingService: mockNotificationOnboardingService,
                analyticsService: MockAnalyticsService(),
                viewControllerBuilder: MockViewControllerBuilder(),
                coordinatorBuilder: MockCoordinatorBuilder.mock,
                completion: {
                    continuation.resume(returning: true)
                }
            )
            sut.start(url: nil)
        }
        #expect(completed)
        #expect(mockNavigationController._setViewControllers == nil)
    }

    @Test
    @MainActor
    func viewPrivacyAction_startsSafari() async {
        let mockNotificationService = MockNotificationService()
        let mockNavigationController = MockNavigationController()
        let mockNotificationOnboardingService = MockNotificationsOnboardingService()
        mockNotificationOnboardingService.hasSeenNotificationsOnboarding = false
        mockNotificationService._stubbedShouldRequestPermission = true

        let mockViewControllerBuilder = MockViewControllerBuilder.mock
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockSafariCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedSafariCoordinator = mockSafariCoordinator

        await withCheckedContinuation { continuation in
            let sut = NotificationOnboardingCoordinator(
                navigationController: mockNavigationController,
                notificationService: mockNotificationService,
                notificationOnboardingService: mockNotificationOnboardingService,
                analyticsService: MockAnalyticsService(),
                viewControllerBuilder: mockViewControllerBuilder,
                coordinatorBuilder: mockCoordinatorBuilder,
                completion: { }
            )

            mockSafariCoordinator._startCalledAction = {
                continuation.resume()
            }
            mockNavigationController._setViewControllersCalledAction = {
                mockViewControllerBuilder._receivedNotificationOnboardingViewPrivacyAction?()
            }
            sut.start(url: nil)
        }

        #expect(mockSafariCoordinator._startCalled)
    }
}
