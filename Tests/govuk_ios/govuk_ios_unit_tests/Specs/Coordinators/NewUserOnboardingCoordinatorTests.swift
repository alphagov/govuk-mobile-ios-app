import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Test
@MainActor
func start_runsThroughNewUserOnboarding() async {
    let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
    let mockNavigationController = UINavigationController()

    let subject = NewUserOnboardingCoordinator(
        coordinatorBuilder: mockCoordinatorBuilder,
        navigationController: mockNavigationController,
        completionAction: { }
    )

    subject.start()
    mockCoordinatorBuilder._receivedLocalAuthenticationOnboardingCompletion?()
    mockCoordinatorBuilder._receivedAnalyticsConsentDismissAction?()
    mockCoordinatorBuilder._receivedTopicOnboardingDidDismissAction?()
    mockCoordinatorBuilder._receivedNotificationOnboardingCompletion?()
}
