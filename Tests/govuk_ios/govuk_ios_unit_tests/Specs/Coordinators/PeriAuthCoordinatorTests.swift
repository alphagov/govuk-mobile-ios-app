import Foundation
import Testing
import Factory
import UIKit

@testable import govuk_ios

@Suite
@MainActor
struct PeriAuthCoordinatorTests {

    @Test
    func start_shouldAttemptTokenRefresh_startsReauthentication() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockAuthenticationService = MockAuthenticationService()
        let subject = PeriAuthCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            navigationController: MockNavigationController(),
            authenticationService: mockAuthenticationService,
            completion: { }
        )
        mockAuthenticationService._shouldAttemptTokenRefresh = true
        let stubbedReauthenticationCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedReauthenticationCoordinator = stubbedReauthenticationCoordinator
        subject.start(url: nil)

        #expect(stubbedReauthenticationCoordinator._startCalled)
    }

    @Test
    func start_shouldNotAttemptTokenRefresh_startsReauthentication() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockAuthenticationService = MockAuthenticationService()
        let subject = PeriAuthCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            navigationController: MockNavigationController(),
            authenticationService: mockAuthenticationService,
            completion: { }
        )
        mockAuthenticationService._shouldAttemptTokenRefresh = false
        let stubbedReauthenticationCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedReauthenticationCoordinator = stubbedReauthenticationCoordinator
        subject.start(url: nil)

        #expect(!stubbedReauthenticationCoordinator._startCalled)
    }

    @Test
    func reauthenticationCompletion_startWelcomeOnboarding() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let subject = PeriAuthCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            navigationController: MockNavigationController(),
            authenticationService: MockAuthenticationService(),
            completion: { }
        )

        let stubbedReauthenticationCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedReauthenticationCoordinator = stubbedReauthenticationCoordinator

        let stubbedWelcomeOnboardingCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedWelcomeOnboardingCoordinator = stubbedWelcomeOnboardingCoordinator

        subject.start(url: nil)

        mockCoordinatorBuilder._receivedReauthenticationCompletion?()

        #expect(stubbedWelcomeOnboardingCoordinator._startCalled)
    }

    @Test
    func welcomeOnboardingCompletion_startsLocalAuthenticationOnboarding() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let subject = PeriAuthCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            navigationController: MockNavigationController(),
            authenticationService: MockAuthenticationService(),
            completion: { }
        )

        let stubbedReauthenticationCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedReauthenticationCoordinator = stubbedReauthenticationCoordinator

        let stubbedWelcomeOnboardingCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedWelcomeOnboardingCoordinator = stubbedWelcomeOnboardingCoordinator

        let stubbedLocalAuthenticationOnboardingCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedWelcomeOnboardingCoordinator = stubbedLocalAuthenticationOnboardingCoordinator

        subject.start(url: nil)

        mockCoordinatorBuilder._receivedReauthenticationCompletion?()
        mockCoordinatorBuilder._receivedWelcomeOnboardingCompletion?()

        #expect(stubbedLocalAuthenticationOnboardingCoordinator._startCalled)
    }

    @Test
    func localAuthenticationOnboardingCompletion_completesCoordinator() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        var completionCalled = false
        let subject = PeriAuthCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            navigationController: MockNavigationController(),
            authenticationService: MockAuthenticationService(),
            completion: {
                completionCalled = true
            }
        )

        let stubbedReauthenticationCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedReauthenticationCoordinator = stubbedReauthenticationCoordinator

        let stubbedWelcomeOnboardingCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedWelcomeOnboardingCoordinator = stubbedWelcomeOnboardingCoordinator

        let stubbedLocalAuthenticationOnboardingCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedWelcomeOnboardingCoordinator = stubbedLocalAuthenticationOnboardingCoordinator

        subject.start(url: nil)

        mockCoordinatorBuilder._receivedReauthenticationCompletion?()
        mockCoordinatorBuilder._receivedWelcomeOnboardingCompletion?()
        mockCoordinatorBuilder._receivedLocalAuthenticationOnboardingCompletion?()

        #expect(completionCalled)
    }
}
