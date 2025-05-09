import UIKit
import Foundation
import Testing

@testable import govuk_ios

@Suite
struct AppCoordinatorTests {
    @Test
    @MainActor
    func start_firstLaunch_startsLaunchCoordinator() {
        let mockCoodinatorBuilder = MockCoordinatorBuilder.mock
        let mockNavigationController = UINavigationController()
        let mockLaunchCoodinator = MockBaseCoordinator(
            navigationController: mockNavigationController
        )
        mockCoodinatorBuilder._stubbedLaunchCoordinator = mockLaunchCoodinator

        let subject = AppCoordinator(
            coordinatorBuilder: mockCoodinatorBuilder,
            navigationController: mockNavigationController
        )

        subject.start()

        #expect(mockCoodinatorBuilder._receivedLaunchNavigationController == mockNavigationController)
        #expect(mockLaunchCoodinator._startCalled)
    }

    @Test
    @MainActor
    func start_secondLaunch_startsTabCoordinator() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockNavigationController = UINavigationController()
        let mockLaunchCoodinator = MockBaseCoordinator(
            navigationController: mockNavigationController
        )
        let mockTabCoodinator = MockBaseCoordinator(
            navigationController: mockNavigationController
        )
        mockCoordinatorBuilder._stubbedLaunchCoordinator = mockLaunchCoodinator
        mockCoordinatorBuilder._stubbedTabCoordinator = mockTabCoodinator

        let subject = AppCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            navigationController: mockNavigationController
        )

        //First launch
        subject.start()

        #expect(mockLaunchCoodinator._startCalled)

        //Finish launch loading
        let launchResult = AppLaunchResponse(
            configResult: .success(.arrange),
            topicResult: .success(TopicResponseItem.arrangeMultiple),
            appVersionProvider: MockAppVersionProvider()
        )
        mockCoordinatorBuilder._receivedLaunchCompletion?(launchResult)
        // This is in order of launch
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

        #expect(mockTabCoodinator._startCalled)

        //Reset values for second launch
        mockLaunchCoodinator._startCalled = false
        mockTabCoodinator._startCalled = false

        //Second launch
        subject.start()

        #expect(!mockLaunchCoodinator._startCalled)
        #expect(mockTabCoodinator._startCalled)
    }

    @Test
    @MainActor
    func successfulSignout_starts_loginCoordinator() throws {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockNavigationController = UINavigationController()
        let mockLaunchCoodinator = MockBaseCoordinator(
            navigationController: mockNavigationController
        )
        mockCoordinatorBuilder._stubbedLaunchCoordinator = mockLaunchCoodinator

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
            appVersionProvider: MockAppVersionProvider()
        )
        mockCoordinatorBuilder._receivedLaunchCompletion?(launchResult)
        // This is in order of launch
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
