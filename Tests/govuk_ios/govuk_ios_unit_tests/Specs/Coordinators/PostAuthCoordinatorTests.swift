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

        await withCheckedContinuation { continuation in
            mockRemoteConfigService._activateCompletionBlock = {
                continuation.resume()
            }
            subject.start(url: nil)
            mockCoordinatorBuilder._receivedAnalyticsConsentCompletion?()
        }

        #expect(mockRemoteConfigService._activateCallCount == 1)
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

        await withCheckedContinuation { continuation in
            mockRemoteConfigService._activateCompletionBlock = {
                continuation.resume()
            }
            subject.start(url: nil)
            mockCoordinatorBuilder._receivedAnalyticsConsentCompletion?()
        }

        #expect(mockTopicOnboardingCoordinator._startCalled)
    }

    @Test
    func topicsOnboardingCompletion_startsNotificationOnboarding() async {
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

        await withCheckedContinuation { continuation in
            mockRemoteConfigService._activateCompletionBlock = {
                continuation.resume()
            }
            subject.start(url: nil)
            mockCoordinatorBuilder._receivedAnalyticsConsentCompletion?()
        }

        mockCoordinatorBuilder._receivedTopicOnboardingDidDismissAction?()

        #expect(mockTopicOnboardingCoordinator._startCalled)
    }

    @Test
    func notificationOnboardingCompletion_completesCoordinator() async {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockRemoteConfigService = MockRemoteConfigService()
        var completionCalled = false
        let subject = PostAuthCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            remoteConfigService: mockRemoteConfigService,
            navigationController: MockNavigationController(),
            completion: {
                completionCalled = true
            }
        )

        let mockTopicOnboardingCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedTopicOnboardingCoordinator = mockTopicOnboardingCoordinator

        await withCheckedContinuation { continuation in
            mockRemoteConfigService._activateCompletionBlock = {
                continuation.resume()
            }
            subject.start(url: nil)
            mockCoordinatorBuilder._receivedAnalyticsConsentCompletion?()
        }

        mockCoordinatorBuilder._receivedTopicOnboardingDidDismissAction?()
        mockCoordinatorBuilder._receivedNotificationOnboardingCompletion?()

        #expect(completionCalled)
    }
    
}
