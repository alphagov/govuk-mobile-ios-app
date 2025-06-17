import Foundation
import Testing

@testable import govuk_ios

@Suite
class LocalAuthenticationOnboardingCoordinatorTests {
    @Test @MainActor
    func start_faceIDEnrolled_setsOnboarding() {
        let mockUserDefaults = MockUserDefaults()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController = MockNavigationController()
        let mockAuthenticationService = MockAuthenticationService()
        let sut = LocalAuthenticationOnboardingCoordinator(
            navigationController: mockNavigationController,
            userDefaults: mockUserDefaults,
            analyticsService: MockAnalyticsService(),
            localAuthenticationService: mockLocalAuthenticationService,
            authenticationService: mockAuthenticationService,
            completionAction: { }
        )
        mockLocalAuthenticationService._stubbedAuthType = .faceID
        sut.start(url: nil)

        #expect(mockNavigationController._setViewControllers?.count == .some(1))
    }

    @Test @MainActor
    func start_touchIDEnrolled_setsOnboarding() {
        let mockUserDefaults = MockUserDefaults()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController = MockNavigationController()
        let mockAuthenticationService = MockAuthenticationService()
        let sut = LocalAuthenticationOnboardingCoordinator(
            navigationController: mockNavigationController,
            userDefaults: mockUserDefaults,
            analyticsService: MockAnalyticsService(),
            localAuthenticationService: mockLocalAuthenticationService,
            authenticationService: mockAuthenticationService,
            completionAction: { }
        )
        mockLocalAuthenticationService._stubbedAuthType = .touchID
        sut.start(url: nil)

        #expect(mockNavigationController._setViewControllers?.count == .some(1))
    }

    @Test @MainActor
    func start_passcodeOnlyOption_callsCompletion() async {
        let mockUserDefaults = MockUserDefaults()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController = MockNavigationController()
        let mockAuthenticationService = MockAuthenticationService()
        mockLocalAuthenticationService._stubbedAuthType = .passcodeOnly
        let completion = await withCheckedContinuation { continuation in
            let sut = LocalAuthenticationOnboardingCoordinator(
                navigationController: mockNavigationController,
                userDefaults: mockUserDefaults,
                analyticsService: MockAnalyticsService(),
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
        let mockUserDefaults = MockUserDefaults()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController = MockNavigationController()
        let mockAuthenticationService = MockAuthenticationService()
        mockLocalAuthenticationService._stubbedAuthType = .none
        let completion = await withCheckedContinuation { continuation in
            let sut = LocalAuthenticationOnboardingCoordinator(
                navigationController: mockNavigationController,
                userDefaults: mockUserDefaults,
                analyticsService: MockAnalyticsService(),
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
        let mockUserDefaults = MockUserDefaults()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController = MockNavigationController()
        let mockAuthenticationService = MockAuthenticationService()
        mockLocalAuthenticationService._stubbedAuthType = .touchID
        mockLocalAuthenticationService._stubbedAuthenticationOnboardingSeen = true
        let completion = await withCheckedContinuation { continuation in
            let sut = LocalAuthenticationOnboardingCoordinator(
                navigationController: mockNavigationController,
                userDefaults: mockUserDefaults,
                analyticsService: MockAnalyticsService(),
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

    @Test @MainActor
    func start_authenticationOnboardingSeen_false_setsOnboarding() async {
        let mockUserDefaults = MockUserDefaults()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController = MockNavigationController()
        let mockAuthenticationService = MockAuthenticationService()
        mockLocalAuthenticationService._stubbedAuthenticationOnboardingSeen = false
        mockLocalAuthenticationService._stubbedAuthType = .touchID
        let sut = LocalAuthenticationOnboardingCoordinator(
            navigationController: mockNavigationController,
            userDefaults: mockUserDefaults,
            analyticsService: MockAnalyticsService(),
            localAuthenticationService: mockLocalAuthenticationService,
            authenticationService: mockAuthenticationService,
            completionAction: {}
        )
        sut.start(url: nil)

        #expect(mockNavigationController._setViewControllers?.count == .some(1))
    }
}
