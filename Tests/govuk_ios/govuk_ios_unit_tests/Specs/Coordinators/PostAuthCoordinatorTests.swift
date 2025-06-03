import Foundation
import Testing
import Factory
import UIKit

@testable import govuk_ios

@Suite
@MainActor
struct PostAuthCoordinatorTests {

    @Test
    func start_startsTopicOnboarding() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let subject = PostAuthCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            navigationController: MockNavigationController(),
            completion: { }
        )

        let stubbedTopicOnboardingCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedTopicOnboardingCoordinator = stubbedTopicOnboardingCoordinator

        subject.start(url: nil)

        #expect(stubbedTopicOnboardingCoordinator._startCalled)
    }

    @Test
    func topicsOnboardingCompletion_startsNotificationOnboarding() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let subject = PostAuthCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            navigationController: MockNavigationController(),
            completion: { }
        )

        let stubbedTopicOnboardingCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedTopicOnboardingCoordinator = stubbedTopicOnboardingCoordinator

        subject.start(url: nil)
        mockCoordinatorBuilder._receivedTopicOnboardingDidDismissAction?()

        #expect(stubbedTopicOnboardingCoordinator._startCalled)
    }

    @Test
    func notificationOnboardingCompletion_completesCoordinator() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        var completionCalled = false
        let subject = PostAuthCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            navigationController: MockNavigationController(),
            completion: {
                completionCalled = true
            }
        )

        let stubbedTopicOnboardingCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedTopicOnboardingCoordinator = stubbedTopicOnboardingCoordinator

        subject.start(url: nil)
        mockCoordinatorBuilder._receivedTopicOnboardingDidDismissAction?()
        mockCoordinatorBuilder._receivedNotificationOnboardingCompletion?()

        #expect(completionCalled)
    }
}
