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
        mockAuthenticationService._stubbedTokenRefreshRequest = .success(tokenRefreshResponse)
        mockLocalAuthenticationService._stubbedAuthenticationOnboardingSeen = true
        let completion = await withCheckedContinuation { continuation in
            let sut = ReauthenticationCoordinator(
                navigationController: mockNavigationController,
                coordinatorBuilder: mockCoordinatorBuilder,
                authenticationService: mockAuthenticationService,
                localAuthenticationService: mockLocalAuthenticationService,
                completionAction: { continuation.resume(returning: true) },
                newUserAction: { }
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
        mockCoordinatorBuilder._stubbedAuthenticationOnboardingCoordinator =
        mockAuthenticationOnboardingCoordinator
        mockAuthenticationService._stubbedTokenRefreshRequest = .failure(.genericError)
        // Need too add continuation as starting coordinator is called after #expect
        let authenticationOnboardingStartCalled = await withCheckedContinuation { continuation in
            mockAuthenticationOnboardingCoordinator._startCalledContinuation = continuation
            let sut = ReauthenticationCoordinator(
                navigationController: mockNavigationController,
                coordinatorBuilder: mockCoordinatorBuilder,
                authenticationService: mockAuthenticationService,
                localAuthenticationService: mockLocalAuthenticationService,
                completionAction: { },
                newUserAction: { }
            )
            sut.start(url: nil)
        }

        #expect(authenticationOnboardingStartCalled)
    }

    @Test @MainActor
    func start_onboardingFlowNotSeen_callsCompletion() async {
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        let mockAuthenticationService = MockAuthenticationService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController =  MockNavigationController()
        mockLocalAuthenticationService._stubbedAuthenticationOnboardingSeen = false
        let completion = await withCheckedContinuation { continuation in
            let sut = ReauthenticationCoordinator(
                navigationController: mockNavigationController,
                coordinatorBuilder: mockCoordinatorBuilder,
                authenticationService: mockAuthenticationService,
                localAuthenticationService: mockLocalAuthenticationService,
                completionAction: { continuation.resume(returning: true) },
                newUserAction: { }
            )
            sut.start(url: nil)
        }

        #expect(completion)
        #expect(mockNavigationController._setViewControllers?.count == .none)
    }
}
