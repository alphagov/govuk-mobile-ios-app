import Foundation
import Testing
import Factory
import UIKit

@testable import govuk_ios

@Suite
@MainActor
struct PreAuthCoordinatorTests {

    @Test
    func start_startsLaunchCoordinator() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let stubbedLaunchCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedLaunchCoordinator = stubbedLaunchCoordinator
        let subject = PreAuthCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            navigationController: MockNavigationController(),
            completion: { }
        )

        subject.start(url: nil)

        #expect(stubbedLaunchCoordinator._startCalled)
    }

    @Test
    func launchCompletion_startsAnalyticsConsent() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let stubbedLaunchCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedLaunchCoordinator = stubbedLaunchCoordinator
        let stubbedAnalyticsConsentCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedAnalyticsConsentCoordinator = stubbedAnalyticsConsentCoordinator
        let subject = PreAuthCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            navigationController: MockNavigationController(),
            completion: { }
        )

        subject.start(url: nil)

        mockCoordinatorBuilder._receivedLaunchCompletion?(.arrangeAvailable)

        #expect(stubbedAnalyticsConsentCoordinator._startCalled)
    }

    @Test
    func analyticsCompletion_startsNotificationConsentCheck() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let stubbedLaunchCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedLaunchCoordinator = stubbedLaunchCoordinator
        let stubbedAnalyticsConsentCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedAnalyticsConsentCoordinator = stubbedAnalyticsConsentCoordinator
        let stubbedNotificationConsentCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedNotificationConsentCoordinator = stubbedNotificationConsentCoordinator
        let subject = PreAuthCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            navigationController: MockNavigationController(),
            completion: { }
        )

        subject.start(url: nil)
        let expectedLaunchResponse = AppLaunchResponse.arrangeAvailable
        mockCoordinatorBuilder._receivedLaunchCompletion?(expectedLaunchResponse)
        mockCoordinatorBuilder._receivedAnalyticsConsentCompletion?()

        #expect(stubbedNotificationConsentCoordinator._startCalled)
        #expect(mockCoordinatorBuilder._receivedNotificationConsentResult == expectedLaunchResponse.notificationConsentResult)
    }

    @Test
    func notificationConsentCheckCompletion_startsAppForcedUpdate() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let stubbedLaunchCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedLaunchCoordinator = stubbedLaunchCoordinator
        let stubbedAnalyticsConsentCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedAnalyticsConsentCoordinator = stubbedAnalyticsConsentCoordinator
        let stubbedNotificationConsentCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedNotificationConsentCoordinator = stubbedNotificationConsentCoordinator
        let stubbedAppForceUpdateCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedAppForcedUpdateCoordinator = stubbedAppForceUpdateCoordinator

        let subject = PreAuthCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            navigationController: MockNavigationController(),
            completion: { }
        )

        subject.start(url: nil)

        let expectedLaunchResponse = AppLaunchResponse.arrangeAvailable
        mockCoordinatorBuilder._receivedLaunchCompletion?(expectedLaunchResponse)
        mockCoordinatorBuilder._receivedAnalyticsConsentCompletion?()
        mockCoordinatorBuilder._receivedNotificationConsentCompletion?()

        #expect(stubbedAppForceUpdateCoordinator._startCalled)
        #expect(mockCoordinatorBuilder._receivedAppForcedUpdateLaunchResponse == expectedLaunchResponse)
    }

    @Test
    func appForcedUpdateCompletion_startsAppUnavailable() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let stubbedLaunchCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedLaunchCoordinator = stubbedLaunchCoordinator
        let stubbedAnalyticsConsentCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedAnalyticsConsentCoordinator = stubbedAnalyticsConsentCoordinator
        let stubbedNotificationConsentCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedNotificationConsentCoordinator = stubbedNotificationConsentCoordinator
        let stubbedAppForceUpdateCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedAppForcedUpdateCoordinator = stubbedAppForceUpdateCoordinator
        let stubbedAppUnavailableCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedAppUnavailableCoordinator = stubbedAppUnavailableCoordinator

        let subject = PreAuthCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            navigationController: MockNavigationController(),
            completion: { }
        )

        subject.start(url: nil)

        let expectedLaunchResponse = AppLaunchResponse.arrangeAvailable
        mockCoordinatorBuilder._receivedLaunchCompletion?(expectedLaunchResponse)
        mockCoordinatorBuilder._receivedAnalyticsConsentCompletion?()
        mockCoordinatorBuilder._receivedNotificationConsentCompletion?()
        mockCoordinatorBuilder._receivedAppForcedUpdateDismissAction?()

        #expect(stubbedAppUnavailableCoordinator._startCalled)
        #expect(mockCoordinatorBuilder._receivedAppUnavailableLaunchResponse == expectedLaunchResponse)
    }

    @Test
    func appUnavailableCompletion_startsAppRecommendUpdate() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let stubbedLaunchCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedLaunchCoordinator = stubbedLaunchCoordinator
        let stubbedAnalyticsConsentCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedAnalyticsConsentCoordinator = stubbedAnalyticsConsentCoordinator
        let stubbedNotificationConsentCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedNotificationConsentCoordinator = stubbedNotificationConsentCoordinator
        let stubbedAppForceUpdateCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedAppForcedUpdateCoordinator = stubbedAppForceUpdateCoordinator
        let stubbedAppUnavailableCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedAppUnavailableCoordinator = stubbedAppUnavailableCoordinator
        let stubbedAppRecommendUpdateCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedAppRecommendUpdateCoordinator = stubbedAppRecommendUpdateCoordinator

        let subject = PreAuthCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            navigationController: MockNavigationController(),
            completion: { }
        )

        subject.start(url: nil)

        let expectedLaunchResponse = AppLaunchResponse.arrangeAvailable
        mockCoordinatorBuilder._receivedLaunchCompletion?(.arrangeAvailable)
        mockCoordinatorBuilder._receivedAnalyticsConsentCompletion?()
        mockCoordinatorBuilder._receivedNotificationConsentCompletion?()
        mockCoordinatorBuilder._receivedAppForcedUpdateDismissAction?()
        mockCoordinatorBuilder._receivedAppUnavailableDismissAction?()

        #expect(stubbedAppRecommendUpdateCoordinator._startCalled)
        #expect(mockCoordinatorBuilder._receivedAppUnavailableLaunchResponse == expectedLaunchResponse)
    }


    @Test
    func appRecommendUpdateCompletion_completesCoordinator() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let stubbedLaunchCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedLaunchCoordinator = stubbedLaunchCoordinator
        let stubbedAnalyticsConsentCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedAnalyticsConsentCoordinator = stubbedAnalyticsConsentCoordinator
        let stubbedNotificationConsentCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedNotificationConsentCoordinator = stubbedNotificationConsentCoordinator
        let stubbedAppForceUpdateCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedAppForcedUpdateCoordinator = stubbedAppForceUpdateCoordinator
        let stubbedAppUnavailableCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedAppUnavailableCoordinator = stubbedAppUnavailableCoordinator
        let stubbedAppRecommendUpdateCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedAppRecommendUpdateCoordinator = stubbedAppRecommendUpdateCoordinator

        var completionCalled = false
        let subject = PreAuthCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            navigationController: MockNavigationController(),
            completion: {
                completionCalled = true
            }
        )

        subject.start(url: nil)

        mockCoordinatorBuilder._receivedLaunchCompletion?(.arrangeAvailable)
        mockCoordinatorBuilder._receivedAnalyticsConsentCompletion?()
        mockCoordinatorBuilder._receivedNotificationConsentCompletion?()
        mockCoordinatorBuilder._receivedAppForcedUpdateDismissAction?()
        mockCoordinatorBuilder._receivedAppUnavailableDismissAction?()
        mockCoordinatorBuilder._receivedAppRecommendUpdateDismissAction?()

        #expect(completionCalled)
    }
}
