import Foundation
import Testing

@testable import govuk_ios

@Suite
class LocalAuthenticationOnboardingCoordinatorTests {
    @Test @MainActor
    func start_faceIDEnrolled_setsOnboarding() {
        let mockUserDefaultsService = MockUserDefaultsService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController = MockNavigationController()
        let mockAuthenticationService = MockAuthenticationService()
        mockLocalAuthenticationService._stubbedIsEnabled = true
        let sut = LocalAuthenticationOnboardingCoordinator(
            navigationController: mockNavigationController,
            userDefaultsService: mockUserDefaultsService,
            localAuthenticationService: mockLocalAuthenticationService,
            authenticationService: mockAuthenticationService,
            completionAction: { }
        )
        mockLocalAuthenticationService._stubbedAvailableAuthType = .faceID
        mockLocalAuthenticationService._stubbedCanEvaluateBiometricsPolicy = true
        sut.start(url: nil)

        #expect(mockNavigationController._setViewControllers?.count == .some(1))
    }

    @Test @MainActor
    func start_featureDisabled_callsCompletion() async {
        let mockUserDefaultsService = MockUserDefaultsService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController = MockNavigationController()
        let mockAuthenticationService = MockAuthenticationService()
        mockLocalAuthenticationService._stubbedIsEnabled = false
        let completion = await withCheckedContinuation { continuation in
            let sut = LocalAuthenticationOnboardingCoordinator(
                navigationController: mockNavigationController,
                userDefaultsService: mockUserDefaultsService,
                localAuthenticationService: mockLocalAuthenticationService,
                authenticationService: mockAuthenticationService,
                completionAction: { continuation.resume(returning: true) }
            )
            mockLocalAuthenticationService._stubbedAvailableAuthType = .faceID
            mockLocalAuthenticationService._stubbedCanEvaluateBiometricsPolicy = true
            sut.start(url: nil)
        }

        #expect(completion)
        #expect(!mockAuthenticationService._encryptRefreshTokenCallSuccess)
    }

    @Test @MainActor
    func start_touchIDEnrolled_setsOnboarding() {
        let mockUserDefaults = MockUserDefaultsService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController = MockNavigationController()
        let mockAuthenticationService = MockAuthenticationService()
        mockLocalAuthenticationService._stubbedIsEnabled = true
        let sut = LocalAuthenticationOnboardingCoordinator(
            navigationController: mockNavigationController,
            userDefaultsService: mockUserDefaults,
            localAuthenticationService: mockLocalAuthenticationService,
            authenticationService: mockAuthenticationService,
            completionAction: { }
        )
        mockLocalAuthenticationService._stubbedAvailableAuthType = .touchID
        mockLocalAuthenticationService._stubbedCanEvaluateBiometricsPolicy = true
        sut.start(url: nil)

        #expect(mockNavigationController._setViewControllers?.count == .some(1))
    }

    @Test @MainActor
    func start_passcodeOnlyOption_callsCompletion() async {
        let mockUserDefaults = MockUserDefaultsService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController = MockNavigationController()
        let mockAuthenticationService = MockAuthenticationService()
        mockLocalAuthenticationService._stubbedAvailableAuthType = .passcodeOnly
        mockLocalAuthenticationService._stubbedIsEnabled = true
        let completion = await withCheckedContinuation { continuation in
            let sut = LocalAuthenticationOnboardingCoordinator(
                navigationController: mockNavigationController,
                userDefaultsService: mockUserDefaults,
                localAuthenticationService: mockLocalAuthenticationService,
                authenticationService: mockAuthenticationService,
                completionAction: { continuation.resume(returning: true) }
            )
            sut.start(url: nil)
        }

        #expect(completion)
        #expect(!mockAuthenticationService._encryptRefreshTokenCallSuccess)
    }

    @Test @MainActor
    func start_noAuthEnrolled_callsCompletion() async {
        let mockUserDefaults = MockUserDefaultsService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController = MockNavigationController()
        let mockAuthenticationService = MockAuthenticationService()
        mockLocalAuthenticationService._stubbedAvailableAuthType = .none
        mockLocalAuthenticationService._stubbedIsEnabled = true
        let completion = await withCheckedContinuation { continuation in
            let sut = LocalAuthenticationOnboardingCoordinator(
                navigationController: mockNavigationController,
                userDefaultsService: mockUserDefaults,
                localAuthenticationService: mockLocalAuthenticationService,
                authenticationService: mockAuthenticationService,
                completionAction: { continuation.resume(returning: true) }
            )
            sut.start(url: nil)
        }

        #expect(completion)
        #expect(mockLocalAuthenticationService.authenticationOnboardingFlowSeen)
        #expect(mockNavigationController._setViewControllers == .none)
        #expect(!mockAuthenticationService._encryptRefreshTokenCallSuccess)
    }

    @Test @MainActor
    func start_authenticationOnboardingSeen_true_callsCompletion() async {
        let mockUserDefaults = MockUserDefaultsService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController = MockNavigationController()
        let mockAuthenticationService = MockAuthenticationService()
        mockLocalAuthenticationService._stubbedAvailableAuthType = .touchID
        mockLocalAuthenticationService._stubbedAuthenticationOnboardingSeen = true
        mockLocalAuthenticationService._stubbedIsEnabled = true
        let completion = await withCheckedContinuation { continuation in
            let sut = LocalAuthenticationOnboardingCoordinator(
                navigationController: mockNavigationController,
                userDefaultsService: mockUserDefaults,
                localAuthenticationService: mockLocalAuthenticationService,
                authenticationService: mockAuthenticationService,
                completionAction: { continuation.resume(returning: true) }
            )
            sut.start(url: nil)
        }

        #expect(completion)
        #expect(mockNavigationController._setViewControllers == .none)
        #expect(!mockAuthenticationService._encryptRefreshTokenCallSuccess)
    }
}
