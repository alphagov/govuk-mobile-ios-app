import Foundation
import Testing
import UIKit
import GOVKit
import Factory

import Onboarding

@testable import govuk_ios

@Suite
class NotificationOnboardingCoordinatorTests {
    @Test
    func start_shouldRequestPermission_startsOnboarding() async {
        let mockNotificationService = MockNotificationService()
        let mockCoordinatorBuilder = await CoordinatorBuilder.mock
        let mockNavigationController = await MockNavigationController()
        let mockNotificationOnboardingService = MockNotificationsOnboardingService()
        mockNotificationOnboardingService.hasSeenNotificationsOnboarding = false
        mockNotificationService._stubbedShouldRequestPermission = true

        let sut = await NotificationOnboardingCoordinator(
            navigationController: mockNavigationController,
            coordinatorBuilder: mockCoordinatorBuilder,
            notificationService: mockNotificationService,
            notificationOnboardingService: mockNotificationOnboardingService,
            analyticsService: MockAnalyticsService(),
            viewControllerBuilder: MockViewControllerBuilder(),
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
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        let mockNavigationController = MockNavigationController()
        let mockNotificationOnboardingService = MockNotificationsOnboardingService()
        mockNotificationService._stubbedShouldRequestPermission = false
        let completed = await withCheckedContinuation { continuation in
            let sut = NotificationOnboardingCoordinator(
                navigationController: mockNavigationController,
                coordinatorBuilder: mockCoordinatorBuilder,
                notificationService: mockNotificationService,
                notificationOnboardingService: mockNotificationOnboardingService,
                analyticsService: MockAnalyticsService(),
                viewControllerBuilder: MockViewControllerBuilder(),
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
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        let mockNavigationController = MockNavigationController()
        let mockNotificationOnboardingService = MockNotificationsOnboardingService()
        mockNotificationService._stubbedShouldRequestPermission = false
        let completed = await withCheckedContinuation { continuation in
            let sut = NotificationOnboardingCoordinator(
                navigationController: mockNavigationController,
                coordinatorBuilder: mockCoordinatorBuilder,
                notificationService: mockNotificationService,
                notificationOnboardingService: mockNotificationOnboardingService,
                analyticsService: MockAnalyticsService(),
                viewControllerBuilder: MockViewControllerBuilder(),
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
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        let mockNavigationController = MockNavigationController()
        let mockNotificationOnboardingService = MockNotificationsOnboardingService()
        mockNotificationService._stubbedShouldRequestPermission = false
        let completed = await withCheckedContinuation { continuation in
            let sut = NotificationOnboardingCoordinator(
                navigationController: mockNavigationController,
                coordinatorBuilder: mockCoordinatorBuilder,
                notificationService: mockNotificationService,
                notificationOnboardingService: mockNotificationOnboardingService,
                analyticsService: MockAnalyticsService(),
                viewControllerBuilder: MockViewControllerBuilder(),
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
    func openAction_startsSafariCoordinator() async {
        let mockNotificationService = MockNotificationService()
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        let mockNavigationController = MockNavigationController()
        let mockNotificationOnboardingService = MockNotificationsOnboardingService()
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let mockSafariCoordinator = MockBaseCoordinator()
        mockNotificationService._stubbedShouldRequestPermission = true
        mockNotificationOnboardingService.hasSeenNotificationsOnboarding = false
        mockCoordinatorBuilder._stubbedSafariCoordinator = mockSafariCoordinator
        let sut = NotificationOnboardingCoordinator(
            navigationController: mockNavigationController,
            coordinatorBuilder: mockCoordinatorBuilder,
            notificationService: mockNotificationService,
            notificationOnboardingService: mockNotificationOnboardingService,
            analyticsService: MockAnalyticsService(),
            viewControllerBuilder: mockViewControllerBuilder,
            completion: {}
        )
        sut.start(url: nil)
        try? await Task.sleep(nanoseconds: 100_000_000)
        let testURL = Constants.API.privacyPolicyUrl
        mockViewControllerBuilder._receivedNotificationOnboardingOpenAction?(testURL)
        #expect(mockCoordinatorBuilder._receivedSafariCoordinatorURL == testURL)
        #expect(mockCoordinatorBuilder._receivedSafariCoordinatorFullScreen == false)
        #expect(mockSafariCoordinator._startCalled)
        #expect(mockSafariCoordinator._receivedStartURL == testURL)
    }

    @Test
    @MainActor
    func openPrivacyPolicy_callsOpenActionWithCorrectURL() {
        var receivedURL: URL?
        let mockAnalyticsService = MockAnalyticsService()
        let sut = NotificationsOnboardingViewModel(
            analyticsService: mockAnalyticsService,
            showImage: true,
            openAction: { url in
                receivedURL = url
            },
            completeAction: {},
            dismissAction: {}
        )
        sut.openPrivacyPolicy()
        #expect(receivedURL == Constants.API.privacyPolicyUrl)
    }

    @Test
    @MainActor
    func openPrivacyPolicy_callsOpenActionOnce() {
        var openActionCallCount = 0
        let mockAnalyticsService = MockAnalyticsService()
        let sut = NotificationsOnboardingViewModel(
            analyticsService: mockAnalyticsService,
            showImage: true,
            openAction: { _ in
                openActionCallCount += 1
            },
            completeAction: {},
            dismissAction: {}
        )
        sut.openPrivacyPolicy()
        #expect(openActionCallCount == 1)
    }
}
