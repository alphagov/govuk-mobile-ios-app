import Foundation
import Testing
import UIKit
import Authentication

@testable import govuk_ios

@Suite
class AuthenticationCoordinatorTests {
    @Test @MainActor
    func start_biometricsEnrolled_shouldEncryptToken_callsCompletion() async {
        let mockAuthenticationService = MockAuthenticationService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController =  MockNavigationController()
        mockLocalAuthenticationService._stubbedCanEvaluateBiometricsPolicy = true
        mockAuthenticationService.authenticationOnboardingFlowSeen = true
        mockAuthenticationService.isLocalAuthenticationSkipped = false
        mockAuthenticationService._stubbedAuthenticationResult = .success(
            .init(returningUser: true)
        )
        let newWindow = UIWindow(frame: UIScreen.main.bounds)
        newWindow.rootViewController = mockNavigationController
        newWindow.makeKeyAndVisible()
        let completion = await withCheckedContinuation { continuation in
            let sut = AuthenticationCoordinator(
                navigationController: mockNavigationController,
                authenticationService: mockAuthenticationService,
                localAuthenticationService: mockLocalAuthenticationService,
                completionAction: { continuation.resume(returning: true) }
            )
            sut.start(url: nil)
        }

        #expect(mockAuthenticationService._encryptRefreshTokenCallSuccess)
        #expect(completion)
    }

    @Test @MainActor
    func start_onboardingFlowNotSeen_shouldntEncryptToken_callsCompletion() async {
        let mockAuthenticationService = MockAuthenticationService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController =  MockNavigationController()
        mockLocalAuthenticationService._stubbedCanEvaluateBiometricsPolicy = true
        mockAuthenticationService.authenticationOnboardingFlowSeen = false
        mockAuthenticationService.isLocalAuthenticationSkipped = false
        mockAuthenticationService._stubbedAuthenticationResult = .success(
            .init(returningUser: true)
        )
        let newWindow = UIWindow(frame: UIScreen.main.bounds)
        newWindow.rootViewController = mockNavigationController
        newWindow.makeKeyAndVisible()
        let completion = await withCheckedContinuation { continuation in
            let sut = AuthenticationCoordinator(
                navigationController: mockNavigationController,
                authenticationService: mockAuthenticationService,
                localAuthenticationService: mockLocalAuthenticationService,
                completionAction: { continuation.resume(returning: true) }
            )
            sut.start(url: nil)
        }

        #expect(!mockAuthenticationService._encryptRefreshTokenCallSuccess)
        #expect(completion)
    }

    @Test @MainActor
    func start_skipsLocalAuthentication_biometricsEnrolled_shouldEncryptToken_callsCompletion() async {
        let mockAuthenticationService = MockAuthenticationService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController =  MockNavigationController()
        mockLocalAuthenticationService._stubbedCanEvaluateBiometricsPolicy = true
        mockAuthenticationService.authenticationOnboardingFlowSeen = true
        mockAuthenticationService.isLocalAuthenticationSkipped = true
        mockAuthenticationService._stubbedAuthenticationResult = .success(
            .init(returningUser: true)
        )
        let newWindow = UIWindow(frame: UIScreen.main.bounds)
        newWindow.rootViewController = mockNavigationController
        newWindow.makeKeyAndVisible()
        let completion = await withCheckedContinuation { continuation in
            let sut = AuthenticationCoordinator(
                navigationController: mockNavigationController,
                authenticationService: mockAuthenticationService,
                localAuthenticationService: mockLocalAuthenticationService,
                completionAction: { continuation.resume(returning: true) }
            )
            sut.start(url: nil)
        }

        #expect(mockAuthenticationService._encryptRefreshTokenCallSuccess)
        #expect(completion)
    }

    @Test @MainActor
    func start_skipsLocalAuthentication_shouldntEncryptToken_callsCompletion() async {
        let mockAuthenticationService = MockAuthenticationService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController =  MockNavigationController()
        mockLocalAuthenticationService._stubbedCanEvaluatePasscodePolicy = true
        mockAuthenticationService.authenticationOnboardingFlowSeen = false
        mockAuthenticationService.isLocalAuthenticationSkipped = true
        mockAuthenticationService._stubbedAuthenticationResult = .success(
            .init(returningUser: true)
        )
        let newWindow = UIWindow(frame: UIScreen.main.bounds)
        newWindow.rootViewController = mockNavigationController
        newWindow.makeKeyAndVisible()
        let completion = await withCheckedContinuation { continuation in
            let sut = AuthenticationCoordinator(
                navigationController: mockNavigationController,
                authenticationService: mockAuthenticationService,
                localAuthenticationService: mockLocalAuthenticationService,
                completionAction: { continuation.resume(returning: true) }
            )
            sut.start(url: nil)
        }

        #expect(!mockAuthenticationService._encryptRefreshTokenCallSuccess)
        #expect(completion)
    }

    @Test @MainActor
    func start_passcodeEnrolled_localAuthNotSkipped_shouldEncryptToken_callsCompletion() async {
        let mockAuthenticationService = MockAuthenticationService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController =  MockNavigationController()
        mockLocalAuthenticationService._stubbedCanEvaluatePasscodePolicy = true
        mockAuthenticationService.authenticationOnboardingFlowSeen = true
        mockAuthenticationService.isLocalAuthenticationSkipped = false
        mockAuthenticationService._stubbedAuthenticationResult = .success(
            .init(returningUser: true)
        )
        let newWindow = UIWindow(frame: UIScreen.main.bounds)
        newWindow.rootViewController = mockNavigationController
        newWindow.makeKeyAndVisible()

        let completion = await withCheckedContinuation { continuation in
            let sut = AuthenticationCoordinator(
                navigationController: mockNavigationController,
                authenticationService: mockAuthenticationService,
                localAuthenticationService: mockLocalAuthenticationService,
                completionAction: { continuation.resume(returning: true) }
            )
            sut.start(url: nil)
        }

        #expect(mockAuthenticationService._encryptRefreshTokenCallSuccess)
        #expect(completion)
    }
}
