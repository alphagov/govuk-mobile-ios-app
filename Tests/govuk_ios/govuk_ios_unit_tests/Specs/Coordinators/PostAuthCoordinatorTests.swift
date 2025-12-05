import Foundation
import Testing
import FactoryKit
import UIKit

@testable import govuk_ios

@Suite
@MainActor
struct PostAuthCoordinatorTests {

    @Test
    func start_startsAnalyticsConsent() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let subject = PostAuthCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            navigationController: MockNavigationController(),
            completion: { }
        )

        let mockAnalyticsConsentCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedAnalyticsConsentCoordinator = mockAnalyticsConsentCoordinator

        subject.start(url: nil)

        #expect(mockAnalyticsConsentCoordinator._startCalled)
    }

    @Test
    func analyticsConsentCompletion_startsTopicOnboarding() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let subject = PostAuthCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            navigationController: MockNavigationController(),
            completion: { }
        )

        let mockTopicOnboardingCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedTopicOnboardingCoordinator = mockTopicOnboardingCoordinator

        subject.start(url: nil)

        mockCoordinatorBuilder._receivedAnalyticsConsentCompletion?()

        #expect(mockTopicOnboardingCoordinator._startCalled)
    }

    @Test
    func topicsOnboardingCompletion_startsNotificationOnboarding() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let subject = PostAuthCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            navigationController: MockNavigationController(),
            completion: { }
        )

        let mockTopicOnboardingCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedTopicOnboardingCoordinator = mockTopicOnboardingCoordinator

        subject.start(url: nil)
        mockCoordinatorBuilder._receivedAnalyticsConsentCompletion?()
        mockCoordinatorBuilder._receivedTopicOnboardingDidDismissAction?()

        #expect(mockTopicOnboardingCoordinator._startCalled)
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

        let mockTopicOnboardingCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedTopicOnboardingCoordinator = mockTopicOnboardingCoordinator

        subject.start(url: nil)
        mockCoordinatorBuilder._receivedAnalyticsConsentCompletion?()
        mockCoordinatorBuilder._receivedTopicOnboardingDidDismissAction?()
        mockCoordinatorBuilder._receivedNotificationOnboardingCompletion?()
        mockCoordinatorBuilder._receivedChatOptInCompletion?()
        mockCoordinatorBuilder._receivedChatOffboardingCompletion?()

        #expect(completionCalled)
    }
}
