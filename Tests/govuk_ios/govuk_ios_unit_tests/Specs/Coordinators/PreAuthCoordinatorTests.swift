import Foundation
import Testing
import FactoryKit
import UIKit

@testable import govuk_ios

@Suite
@MainActor
struct PreAuthCoordinatorTests {

    @Test
    func start_startsJailbreakCoordinator() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let stubbedJailbreakCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedJailbreakCoordinator = stubbedJailbreakCoordinator
        let subject = PreAuthCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            navigationController: MockNavigationController(),
            completion: { }
        )

        subject.start(url: nil)

        #expect(stubbedJailbreakCoordinator._startCalled)
    }

    @Test
    func jailbreakCompletion_startsLaunchCoordinator() async throws {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let stubbedJailbreakCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedJailbreakCoordinator = stubbedJailbreakCoordinator
        let stubbedLaunchCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedLaunchCoordinator = stubbedLaunchCoordinator
        let subject = PreAuthCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            navigationController: MockNavigationController(),
            completion: { }
        )

        subject.start(url: nil)

        mockCoordinatorBuilder._receivedJailbreakDismissAction?()

        #expect(stubbedLaunchCoordinator._startCalled)
    }

    @Test
    func launchCompletion_startsNotificationConsentCheck() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let stubbedJailbreakCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedJailbreakCoordinator = stubbedJailbreakCoordinator
        let stubbedLaunchCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedLaunchCoordinator = stubbedLaunchCoordinator
        let stubbedNotificationConsentCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedNotificationConsentCoordinator = stubbedNotificationConsentCoordinator
        let subject = PreAuthCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            navigationController: MockNavigationController(),
            completion: { }
        )

        subject.start(url: nil)

        mockCoordinatorBuilder._receivedJailbreakDismissAction?()
        let expectedLaunchResponse = AppLaunchResponse.arrangeAvailable
        mockCoordinatorBuilder._receivedLaunchCompletion?(expectedLaunchResponse)

        #expect(stubbedNotificationConsentCoordinator._startCalled)
        #expect(mockCoordinatorBuilder._receivedNotificationConsentResult == expectedLaunchResponse.notificationConsentResult)
    }

    @Test
    func notificationConsentCheckCompletion_startsAppForcedUpdate() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let stubbedJailbreakCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedJailbreakCoordinator = stubbedJailbreakCoordinator
        let stubbedLaunchCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedLaunchCoordinator = stubbedLaunchCoordinator
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

        mockCoordinatorBuilder._receivedJailbreakDismissAction?()
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
        let stubbedJailbreakCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedJailbreakCoordinator = stubbedJailbreakCoordinator
        let stubbedLaunchCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedLaunchCoordinator = stubbedLaunchCoordinator
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

        mockCoordinatorBuilder._receivedJailbreakDismissAction?()
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
        let stubbedJailbreakCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedJailbreakCoordinator = stubbedJailbreakCoordinator
        let stubbedLaunchCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedLaunchCoordinator = stubbedLaunchCoordinator
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

        mockCoordinatorBuilder._receivedJailbreakDismissAction?()
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
        let stubbedJailbreakCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedJailbreakCoordinator = stubbedJailbreakCoordinator
        let stubbedLaunchCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedLaunchCoordinator = stubbedLaunchCoordinator
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

        mockCoordinatorBuilder._receivedJailbreakDismissAction?()
        mockCoordinatorBuilder._receivedLaunchCompletion?(.arrangeAvailable)
        mockCoordinatorBuilder._receivedAnalyticsConsentCompletion?()
        mockCoordinatorBuilder._receivedNotificationConsentCompletion?()
        mockCoordinatorBuilder._receivedAppForcedUpdateDismissAction?()
        mockCoordinatorBuilder._receivedAppUnavailableDismissAction?()
        mockCoordinatorBuilder._receivedAppRecommendUpdateDismissAction?()

        #expect(completionCalled)
    }
}
