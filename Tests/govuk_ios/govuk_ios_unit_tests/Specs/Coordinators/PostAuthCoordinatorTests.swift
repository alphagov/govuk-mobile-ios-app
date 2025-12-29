import Foundation
import Testing
import Factory
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
            remoteConfigService: MockRemoteConfigService(),
            navigationController: MockNavigationController(),
            completion: { }
        )

        let mockAnalyticsConsentCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedAnalyticsConsentCoordinator = mockAnalyticsConsentCoordinator

        subject.start(url: nil)

        #expect(mockAnalyticsConsentCoordinator._startCalled)
    }
    
    @Test
    func analyticsConsentCompletion_triggersRemoteConfigActivation() async {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockRemoteConfigService = MockRemoteConfigService()
        let subject = PostAuthCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            remoteConfigService: mockRemoteConfigService,
            navigationController: MockNavigationController(),
            completion: { }
        )
        
        subject.start(url: nil)
        
        mockCoordinatorBuilder._receivedAnalyticsConsentCompletion?()
        await subject.remoteConfigActivationTask?.value
        
        #expect(mockRemoteConfigService.activateCallCount == 1)
    }

    @Test
    func analyticsConsentCompletion_startsTopicOnboarding() async {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockRemoteConfigService = MockRemoteConfigService()
        let subject = PostAuthCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            remoteConfigService: mockRemoteConfigService,
            navigationController: MockNavigationController(),
            completion: { }
        )

        let mockTopicOnboardingCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedTopicOnboardingCoordinator = mockTopicOnboardingCoordinator

        subject.start(url: nil)

        mockCoordinatorBuilder._receivedAnalyticsConsentCompletion?()
        await subject.remoteConfigActivationTask?.value

        #expect(mockTopicOnboardingCoordinator._startCalled)
    }

    @Test
    func topicsOnboardingCompletion_startsNotificationOnboarding() async {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let subject = PostAuthCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            remoteConfigService: MockRemoteConfigService(),
            navigationController: MockNavigationController(),
            completion: { }
        )

        let mockTopicOnboardingCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedTopicOnboardingCoordinator = mockTopicOnboardingCoordinator

        subject.start(url: nil)
        mockCoordinatorBuilder._receivedAnalyticsConsentCompletion?()
        await subject.remoteConfigActivationTask?.value
        mockCoordinatorBuilder._receivedTopicOnboardingDidDismissAction?()

        #expect(mockTopicOnboardingCoordinator._startCalled)
    }

    @Test
    func notificationOnboardingCompletion_completesCoordinator() async {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        var completionCalled = false
        let subject = PostAuthCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            remoteConfigService: MockRemoteConfigService(),
            navigationController: MockNavigationController(),
            completion: {
                completionCalled = true
            }
        )

        let mockTopicOnboardingCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedTopicOnboardingCoordinator = mockTopicOnboardingCoordinator

        subject.start(url: nil)
        mockCoordinatorBuilder._receivedAnalyticsConsentCompletion?()
        await subject.remoteConfigActivationTask?.value
        mockCoordinatorBuilder._receivedTopicOnboardingDidDismissAction?()
        mockCoordinatorBuilder._receivedNotificationOnboardingCompletion?()
        mockCoordinatorBuilder._receivedChatOptInCompletion?()
        mockCoordinatorBuilder._receivedChatOffboardingCompletion?()

        #expect(completionCalled)
    }
    
}
