import Foundation
import Testing

@testable import govuk_ios

@Suite
class ReauthenticationCoordinatorTests {
    @Test @MainActor
    func start_shouldReauthenticate_successfulTokenResponse_callsCompletion() async {
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        let mockAuthenticationService = MockAuthenticationService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController =  MockNavigationController()
        let tokenRefreshResponse = TokenRefreshResponse(
            accessToken: "access_token",
            idToken: "id_token"
        )
        mockLocalAuthenticationService._stubbedCanEvaluateBiometricsPolicy = true
        mockAuthenticationService._stubbedTokenRefreshRequest = .success(tokenRefreshResponse)
        mockLocalAuthenticationService._stubbedAuthenticationOnboardingSeen = true
        let completion = await withCheckedContinuation { continuation in
            let sut = ReAuthenticationCoordinator(
                navigationController: mockNavigationController,
                coordinatorBuilder: mockCoordinatorBuilder,
                authenticationService: mockAuthenticationService,
                localAuthenticationService: mockLocalAuthenticationService,
                completionAction: { continuation.resume(returning: true) }
            )
            sut.start(url: nil)
        }

        #expect(completion)
        #expect(mockNavigationController._setViewControllers?.count == .none)
    }

    @Test @MainActor
    func start_shouldReauthenticate_unsuccessfulTokenResponse_startsAuthenticationLogin() async {
        let mockAuthenticationOnboardingCoordinator = MockBaseCoordinator()
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        let mockAuthenticationService = MockAuthenticationService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController =  MockNavigationController()
        mockLocalAuthenticationService._stubbedAuthenticationOnboardingSeen = true
        mockLocalAuthenticationService._stubbedCanEvaluateBiometricsPolicy = true
        mockCoordinatorBuilder._stubbedWelcomeOnboardingCoordinator =
        mockAuthenticationOnboardingCoordinator
        mockAuthenticationService._stubbedTokenRefreshRequest = .failure(.genericError)
        // Need too add continuation as starting coordinator is called after #expect
        let authenticationOnboardingStartCalled = await withCheckedContinuation { continuation in
            mockAuthenticationOnboardingCoordinator._startCalledContinuation = continuation
            let sut = ReAuthenticationCoordinator(
                navigationController: mockNavigationController,
                coordinatorBuilder: mockCoordinatorBuilder,
                authenticationService: mockAuthenticationService,
                localAuthenticationService: mockLocalAuthenticationService,
                completionAction: { }
            )
            sut.start(url: nil)
        }

        #expect(authenticationOnboardingStartCalled)
    }

    @Test @MainActor
    func start_biometricsChanged_startsAuthenticationLogin() async {
        let mockAuthenticationOnboardingCoordinator = MockBaseCoordinator()
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        let mockAuthenticationService = MockAuthenticationService()
        let mockNavigationController =  MockNavigationController()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        mockLocalAuthenticationService._stubbedAuthenticationOnboardingSeen = true
        mockLocalAuthenticationService._stubbedBiometricsHaveChanged = true
        mockCoordinatorBuilder._stubbedWelcomeOnboardingCoordinator =
        mockAuthenticationOnboardingCoordinator
        mockAuthenticationService._stubbedTokenRefreshRequest = .failure(.genericError)
        let authenticationOnboardingStartCalled = await withCheckedContinuation { continuation in
            mockAuthenticationOnboardingCoordinator._startCalledContinuation = continuation
            let sut = ReAuthenticationCoordinator(
                navigationController: mockNavigationController,
                coordinatorBuilder: mockCoordinatorBuilder,
                authenticationService: mockAuthenticationService,
                localAuthenticationService: mockLocalAuthenticationService,
                completionAction: { continuation.resume(returning: true) }
            )
            sut.start(url: nil)
        }

        #expect(authenticationOnboardingStartCalled)
    }

    @Test @MainActor
    func start_touchId_disabled_startsAuthenticationLogin() async {
        let mockAuthenticationOnboardingCoordinator = MockBaseCoordinator()
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        let mockAuthenticationService = MockAuthenticationService()
        let mockNavigationController =  MockNavigationController()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        mockLocalAuthenticationService._stubbedAvailableAuthType = .touchID
        mockLocalAuthenticationService._stubbedTouchIdEnabled = false
        mockLocalAuthenticationService._stubbedAuthenticationOnboardingSeen = true
        mockCoordinatorBuilder._stubbedWelcomeOnboardingCoordinator =
        mockAuthenticationOnboardingCoordinator
        let authenticationOnboardingStartCalled = await withCheckedContinuation { continuation in
            mockAuthenticationOnboardingCoordinator._startCalledContinuation = continuation
            let sut = ReAuthenticationCoordinator(
                navigationController: mockNavigationController,
                coordinatorBuilder: mockCoordinatorBuilder,
                authenticationService: mockAuthenticationService,
                localAuthenticationService: mockLocalAuthenticationService,
                completionAction: { continuation.resume(returning: true) }
            )
            sut.start(url: nil)
        }

        #expect(authenticationOnboardingStartCalled)
    }

    @Test @MainActor
    func start_touchId_enabled_startsAuthenticationLogin() async {
        let mockAuthenticationOnboardingCoordinator = MockBaseCoordinator()
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        let mockAuthenticationService = MockAuthenticationService()
        let mockNavigationController =  MockNavigationController()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        mockLocalAuthenticationService._stubbedAvailableAuthType = .touchID
        mockLocalAuthenticationService._stubbedTouchIdEnabled = true
        mockLocalAuthenticationService._stubbedAuthenticationOnboardingSeen = true
        mockCoordinatorBuilder._stubbedWelcomeOnboardingCoordinator =
        mockAuthenticationOnboardingCoordinator
        let completion = await withCheckedContinuation { continuation in
            mockAuthenticationOnboardingCoordinator._startCalledContinuation = continuation
            let sut = ReAuthenticationCoordinator(
                navigationController: mockNavigationController,
                coordinatorBuilder: mockCoordinatorBuilder,
                authenticationService: mockAuthenticationService,
                localAuthenticationService: mockLocalAuthenticationService,
                completionAction: { continuation.resume(returning: true) }
            )
            sut.start(url: nil)
        }

        #expect(completion)
        #expect(mockNavigationController._setViewControllers?.count == .none)
    }

    @Test @MainActor
    func start_onboardingFlowNotSeen_callsCompletion() async {
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        let mockAuthenticationService = MockAuthenticationService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController =  MockNavigationController()
        mockLocalAuthenticationService._stubbedAuthenticationOnboardingSeen = false
        let completion = await withCheckedContinuation { continuation in
            let sut = ReAuthenticationCoordinator(
                navigationController: mockNavigationController,
                coordinatorBuilder: mockCoordinatorBuilder,
                authenticationService: mockAuthenticationService,
                localAuthenticationService: mockLocalAuthenticationService,
                completionAction: { continuation.resume(returning: true) }
            )
            sut.start(url: nil)
        }

        #expect(completion)
        #expect(mockNavigationController._setViewControllers?.count == .none)
    }

    @Test @MainActor
    func start_faceIdSkipped_callsCompletion() async {
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        let mockAuthenticationService = MockAuthenticationService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController =  MockNavigationController()
        mockLocalAuthenticationService._stubbedFaceIdSkipped = true
        let completion = await withCheckedContinuation { continuation in
            let sut = ReAuthenticationCoordinator(
                navigationController: mockNavigationController,
                coordinatorBuilder: mockCoordinatorBuilder,
                authenticationService: mockAuthenticationService,
                localAuthenticationService: mockLocalAuthenticationService,
                completionAction: { continuation.resume(returning: true) }
            )
            sut.start(url: nil)
        }

        #expect(completion)
        #expect(mockNavigationController._setViewControllers?.count == .none)
    }
}
