import Foundation
import Testing
import UIKit

import Onboarding

@testable import govuk_ios

@Suite
class NotificationOnboardingCoordinatorTests {
    @Test
    func start_shouldRequestPermission_startsOnboarding() async {
        let mockNotificationService = MockNotificationService()
        let mockNavigationController = await MockNavigationController()
        let mockNotificationOnboardingService = MockNotificationsOnboardingService()
        mockNotificationOnboardingService.hasSeenNotificationsOnboarding = false
        mockNotificationService._stubbedShouldRequestPermission = true

        let sut = await NotificationOnboardingCoordinator(
            navigationController: mockNavigationController,
            notificationService: mockNotificationService,
            notificationOnboardingService: mockNotificationOnboardingService,
            analyticsService: MockAnalyticsService(),
            viewControllerBuilder: MockViewControllerBuilder(),
            coordinatorBuilder: MockCoordinatorBuilder.mock,
            completion: {}
        )
        mockNotificationService._stubbedShouldRequestPermission = true
        await sut.start(url: nil)

        await #expect(mockNavigationController._setViewControllers?.count == .some(1))
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
}
