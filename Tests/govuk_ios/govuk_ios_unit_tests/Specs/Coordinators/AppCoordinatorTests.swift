import UIKit
import Foundation
import Testing

@testable import govuk_ios

@Suite
struct AppCoordinatorTests {
    @Test
    @MainActor
    func start_firstLaunch_startsLaunchCoordinator() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockNavigationController = UINavigationController()
        let mockLaunchCoordinator = MockBaseCoordinator(
            navigationController: mockNavigationController
        )
        mockCoordinatorBuilder._stubbedLaunchCoordinator = mockLaunchCoordinator

        let subject = AppCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            navigationController: mockNavigationController
        )

        subject.start()

        #expect(mockCoordinatorBuilder._receivedLaunchNavigationController == mockNavigationController)
        #expect(mockLaunchCoordinator._startCalled)
    }

    @Test
    @MainActor
    func start_secondLaunch_startsTabCoordinator() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockNavigationController = UINavigationController()
        let mockLaunchCoordinator = MockBaseCoordinator(
            navigationController: mockNavigationController
        )
        let mockTabCoordinator = MockBaseCoordinator(
            navigationController: mockNavigationController
        )
        mockCoordinatorBuilder._stubbedLaunchCoordinator = mockLaunchCoordinator
        mockCoordinatorBuilder._stubbedTabCoordinator = mockTabCoordinator

        let subject = AppCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            navigationController: mockNavigationController
        )

        //First launch
        subject.start()

        #expect(mockLaunchCoordinator._startCalled)

        //Finish launch loading
        let launchResult = AppLaunchResponse(
            configResult: .success(.arrange),
            topicResult: .success(TopicResponseItem.arrangeMultiple),
            notificationConsentResult: .aligned,
            appVersionProvider: MockAppVersionProvider()
        )
        // This is in order of launch
        mockCoordinatorBuilder._receivedLaunchCompletion?(launchResult)
        mockCoordinatorBuilder._receivedNotificationConsentCompletion?()
        mockCoordinatorBuilder._receivedAppForcedUpdateDismissAction?()
        mockCoordinatorBuilder._receivedAppUnavailableDismissAction?()
        mockCoordinatorBuilder._receivedAppRecommendUpdateDismissAction?()
        mockCoordinatorBuilder._receivedReauthenticationCompletion?()
        mockCoordinatorBuilder._receivedAnalyticsConsentDismissAction?()
        mockCoordinatorBuilder._receivedOnboardingDismissAction?()
        mockCoordinatorBuilder._receivedAuthenticationOnboardingCompletion?()
        mockCoordinatorBuilder._receivedLocalAuthenticationOnboardingCompletion?()
        mockCoordinatorBuilder._receivedTopicOnboardingDidDismissAction?()
        mockCoordinatorBuilder._receivedNotificationOnboardingCompletion?()

        #expect(mockTabCoordinator._startCalled)

        //Reset values for second launch
        mockLaunchCoordinator._startCalled = false
        mockTabCoordinator._startCalled = false

        //Second launch
        subject.start()

        mockCoordinatorBuilder._receivedRelaunchCompletion?()

        #expect(!mockLaunchCoordinator._startCalled)
        #expect(mockTabCoordinator._startCalled)
    }

    @Test
    @MainActor
    func successfulSignout_startsLoginCoordinator() throws {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockNavigationController = UINavigationController()
        let mockLaunchCoordinator = MockBaseCoordinator(
            navigationController: mockNavigationController
        )
        mockCoordinatorBuilder._stubbedLaunchCoordinator = mockLaunchCoordinator

        let tabCoordinator = TabCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            navigationController: mockNavigationController,
            analyticsService: MockAnalyticsService()
        )

        let mockSignedOutCoordinator = MockBaseCoordinator(
            navigationController: mockNavigationController
        )

        let mockAuthenticationOnboardingCoordinator = MockBaseCoordinator(
            navigationController: mockNavigationController
        )

        mockCoordinatorBuilder._stubbedTabCoordinator = tabCoordinator
        mockCoordinatorBuilder._stubbedSignedOutCoordinator = mockSignedOutCoordinator
        mockCoordinatorBuilder
            ._stubbedAuthenticationOnboardingCoordinator = mockAuthenticationOnboardingCoordinator

        let subject = AppCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            navigationController: mockNavigationController
        )

        //First launch
        subject.start()
        //Finish launch loading
        let launchResult = AppLaunchResponse(
            configResult: .success(.arrange),
            topicResult: .success(TopicResponseItem.arrangeMultiple),
            notificationConsentResult: .aligned,
            appVersionProvider: MockAppVersionProvider()
        )
        // This is in order of launch
        mockCoordinatorBuilder._receivedLaunchCompletion?(launchResult)
        mockCoordinatorBuilder._receivedNotificationConsentCompletion?()
        mockCoordinatorBuilder._receivedAppForcedUpdateDismissAction?()
        mockCoordinatorBuilder._receivedAppUnavailableDismissAction?()
        mockCoordinatorBuilder._receivedAppRecommendUpdateDismissAction?()
        mockCoordinatorBuilder._receivedReauthenticationCompletion?()
        mockCoordinatorBuilder._receivedAnalyticsConsentDismissAction?()
        mockCoordinatorBuilder._receivedOnboardingDismissAction?()
        mockCoordinatorBuilder._receivedAuthenticationOnboardingCompletion?()
        mockCoordinatorBuilder._receivedLocalAuthenticationOnboardingCompletion?()
        mockCoordinatorBuilder._receivedTopicOnboardingDidDismissAction?()
        mockCoordinatorBuilder._receivedNotificationOnboardingCompletion?()

        tabCoordinator.finish()
        #expect(mockSignedOutCoordinator._startCalled)

        mockCoordinatorBuilder._receivedSignedOutCompletion?(false)
        #expect(mockAuthenticationOnboardingCoordinator._startCalled)
    }
}
