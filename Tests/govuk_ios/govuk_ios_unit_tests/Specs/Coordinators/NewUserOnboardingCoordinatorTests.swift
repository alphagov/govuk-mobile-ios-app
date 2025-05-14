import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Test
@MainActor
func start_runsThroughNewUserOnboarding() {
    let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
    let mockNavigationController = UINavigationController()
    let mockTabCoodinator = MockBaseCoordinator(
        navigationController: mockNavigationController
    )
    mockCoordinatorBuilder._stubbedTabCoordinator = mockTabCoodinator

    let subject = NewUserOnboardingCoordinator(
        coordinatorBuilder: mockCoordinatorBuilder,
        navigationController: mockNavigationController
    )

    subject.start()

    mockCoordinatorBuilder._receivedLocalAuthenticationOnboardingCompletion?()
    mockCoordinatorBuilder._receivedAnalyticsConsentDismissAction?()
    mockCoordinatorBuilder._receivedOnboardingDismissAction?()
    mockCoordinatorBuilder._receivedTopicOnboardingDidDismissAction?()
    mockCoordinatorBuilder._receivedNotificationOnboardingCompletion?()

    #expect(mockTabCoodinator._startCalled)
}
