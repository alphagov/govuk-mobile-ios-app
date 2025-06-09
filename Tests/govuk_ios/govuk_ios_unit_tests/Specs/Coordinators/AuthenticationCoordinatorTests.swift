import Foundation
import Testing
import UIKit
import Authentication

@testable import govuk_ios

@Suite
@MainActor
class AuthenticationCoordinatorTests {
    @Test
    func start_biometricsEnrolled_shouldEncryptToken_callsCompletion() async {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockAuthenticationService = MockAuthenticationService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController =  MockNavigationController()
        mockLocalAuthenticationService._stubbedCanEvaluateBiometricsPolicy = true
        mockLocalAuthenticationService._stubbedAuthenticationOnboardingSeen = true
        mockLocalAuthenticationService._stubbedLocalAuthenticationEnabled = true
        mockAuthenticationService._stubbedAuthenticationResult = .success(
            .init(returningUser: true)
        )
        let mockAnalyticsService = MockAnalyticsService()
        let newWindow = UIWindow(frame: UIScreen.main.bounds)
        newWindow.rootViewController = mockNavigationController
        newWindow.makeKeyAndVisible()
        await withCheckedContinuation { continuation in
            let sut = AuthenticationCoordinator(
                navigationController: mockNavigationController,
                coordinatorBuilder: mockCoordinatorBuilder,
                authenticationService: mockAuthenticationService,
                localAuthenticationService: mockLocalAuthenticationService,
                analyticsService: mockAnalyticsService,
                completionAction: { },
                handleError: { _ in }
            )
            sut.start(url: nil)
            mockCoordinatorBuilder._signInSuccessCallAction = {
                continuation.resume()
            }
        }

        #expect(mockAuthenticationService._encryptRefreshTokenCallSuccess)
    }

    @Test
    func start_signinSuccess_startsSignInSuccess() async {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockSignInSuccessCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedSignInSuccessCoordinator = mockSignInSuccessCoordinator
        let mockAuthenticationService = MockAuthenticationService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController =  MockNavigationController()
        mockLocalAuthenticationService._stubbedCanEvaluateBiometricsPolicy = true
        mockLocalAuthenticationService._stubbedAuthenticationOnboardingSeen = false
        mockLocalAuthenticationService._stubbedLocalAuthenticationEnabled = false
        mockAuthenticationService._stubbedAuthenticationResult = .success(
            .init(returningUser: false)
        )
        let mockAnalyticsService = MockAnalyticsService()
        let newWindow = UIWindow(frame: UIScreen.main.bounds)
        newWindow.rootViewController = mockNavigationController
        newWindow.makeKeyAndVisible()
        await withCheckedContinuation { continuation in
            let sut = AuthenticationCoordinator(
                navigationController: mockNavigationController,
                coordinatorBuilder: mockCoordinatorBuilder,
                authenticationService: mockAuthenticationService,
                localAuthenticationService: mockLocalAuthenticationService,
                analyticsService: mockAnalyticsService,
                completionAction: { },
                handleError: { _ in }
            )
            sut.start(url: nil)
            mockCoordinatorBuilder._signInSuccessCallAction = {
                continuation.resume()
            }
        }

        #expect(mockSignInSuccessCoordinator._startCalled)
    }

    @Test
    func signinSuccess_newUser_resetsAnalyticsConsent() async {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockSignInSuccessCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedSignInSuccessCoordinator = mockSignInSuccessCoordinator
        let mockAuthenticationService = MockAuthenticationService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController =  MockNavigationController()
        mockLocalAuthenticationService._stubbedCanEvaluateBiometricsPolicy = true
        mockLocalAuthenticationService._stubbedAuthenticationOnboardingSeen = false
        mockLocalAuthenticationService._stubbedLocalAuthenticationEnabled = false
        mockAuthenticationService._stubbedAuthenticationResult = .success(
            .init(returningUser: false)
        )
        let mockAnalyticsService = MockAnalyticsService()
        let newWindow = UIWindow(frame: UIScreen.main.bounds)
        newWindow.rootViewController = mockNavigationController
        newWindow.makeKeyAndVisible()
        await withCheckedContinuation { continuation in
            let sut = AuthenticationCoordinator(
                navigationController: mockNavigationController,
                coordinatorBuilder: mockCoordinatorBuilder,
                authenticationService: mockAuthenticationService,
                localAuthenticationService: mockLocalAuthenticationService,
                analyticsService: mockAnalyticsService,
                completionAction: { },
                handleError: { _ in }
            )
            sut.start(url: nil)
            mockCoordinatorBuilder._signInSuccessCallAction = {
                continuation.resume()
            }
        }

        #expect(mockAnalyticsService._resetConsentCalled)
    }

    @Test
    func signinSuccess_returningUser_keepsAnalyticsConsent() async {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockSignInSuccessCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedSignInSuccessCoordinator = mockSignInSuccessCoordinator
        let mockAuthenticationService = MockAuthenticationService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController =  MockNavigationController()
        mockLocalAuthenticationService._stubbedCanEvaluateBiometricsPolicy = true
        mockLocalAuthenticationService._stubbedAuthenticationOnboardingSeen = false
        mockLocalAuthenticationService._stubbedLocalAuthenticationEnabled = false
        mockAuthenticationService._stubbedAuthenticationResult = .success(
            .init(returningUser: true)
        )
        let mockAnalyticsService = MockAnalyticsService()
        let newWindow = UIWindow(frame: UIScreen.main.bounds)
        newWindow.rootViewController = mockNavigationController
        newWindow.makeKeyAndVisible()
        await withCheckedContinuation { continuation in
            let sut = AuthenticationCoordinator(
                navigationController: mockNavigationController,
                coordinatorBuilder: mockCoordinatorBuilder,
                authenticationService: mockAuthenticationService,
                localAuthenticationService: mockLocalAuthenticationService,
                analyticsService: mockAnalyticsService,
                completionAction: { },
                handleError: { _ in }
            )
            sut.start(url: nil)
            mockCoordinatorBuilder._signInSuccessCallAction = {
                continuation.resume()
            }
        }

        #expect(!mockAnalyticsService._resetConsentCalled)
    }

    @Test
    func signinSuccessCompletion_completesCoordinator() async {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockSignInCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedSignInSuccessCoordinator = mockSignInCoordinator
        let mockAuthenticationService = MockAuthenticationService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController =  MockNavigationController()
        mockLocalAuthenticationService._stubbedCanEvaluateBiometricsPolicy = true
        mockLocalAuthenticationService._stubbedAuthenticationOnboardingSeen = false
        mockLocalAuthenticationService._stubbedLocalAuthenticationEnabled = false
        mockAuthenticationService._stubbedAuthenticationResult = .success(
            .init(returningUser: true)
        )
        let mockAnalyticsService = MockAnalyticsService()
        let newWindow = UIWindow(frame: UIScreen.main.bounds)
        newWindow.rootViewController = mockNavigationController
        newWindow.makeKeyAndVisible()
        let completion = await withCheckedContinuation { continuation in
            let sut = AuthenticationCoordinator(
                navigationController: mockNavigationController,
                coordinatorBuilder: mockCoordinatorBuilder,
                authenticationService: mockAuthenticationService,
                localAuthenticationService: mockLocalAuthenticationService,
                analyticsService: mockAnalyticsService,
                completionAction: { continuation.resume(returning: true) },
                handleError: { _ in }
            )
            sut.start(url: nil)
            mockCoordinatorBuilder._signInSuccessCallAction = {
                mockCoordinatorBuilder._receivedSignInSuccessCompletion?()
            }
        }

        #expect(completion)
    }

    @Test
    func start_localAuthenticationEnabled_biometricsEnrolled_shouldEncryptToken_encryptsRefreshToken() async {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockAuthenticationService = MockAuthenticationService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController =  MockNavigationController()
        mockLocalAuthenticationService._stubbedCanEvaluateBiometricsPolicy = true
        mockLocalAuthenticationService._stubbedAuthenticationOnboardingSeen = true
        mockLocalAuthenticationService._stubbedLocalAuthenticationEnabled = true
        mockAuthenticationService._stubbedAuthenticationResult = .success(
            .init(returningUser: true)
        )
        let mockAnalyticsService = MockAnalyticsService()
        let newWindow = UIWindow(frame: UIScreen.main.bounds)
        newWindow.rootViewController = mockNavigationController
        newWindow.makeKeyAndVisible()
        await withCheckedContinuation { continuation in
            let sut = AuthenticationCoordinator(
                navigationController: mockNavigationController,
                coordinatorBuilder: mockCoordinatorBuilder,
                authenticationService: mockAuthenticationService,
                localAuthenticationService: mockLocalAuthenticationService,
                analyticsService: mockAnalyticsService,
                completionAction: { },
                handleError: { _ in }
            )
            sut.start(url: nil)
            mockCoordinatorBuilder._signInSuccessCallAction = {
                continuation.resume()
            }
        }

        #expect(mockAuthenticationService._encryptRefreshTokenCallSuccess)
    }

    @Test
    func start_localAuthenticationDisabled_shouldntEncryptToken_doesntEncryptRefreshToken() async {
        let mockAuthenticationService = MockAuthenticationService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockNavigationController =  MockNavigationController()
        mockLocalAuthenticationService._stubbedAuthenticationOnboardingSeen = true
        mockLocalAuthenticationService._stubbedLocalAuthenticationEnabled = false
        mockAuthenticationService._stubbedAuthenticationResult = .success(
            .init(returningUser: true)
        )
        let mockAnalyticsService = MockAnalyticsService()
        let newWindow = UIWindow(frame: UIScreen.main.bounds)
        newWindow.rootViewController = mockNavigationController
        newWindow.makeKeyAndVisible()
        await withCheckedContinuation { continuation in
            let sut = AuthenticationCoordinator(
                navigationController: mockNavigationController,
                coordinatorBuilder: mockCoordinatorBuilder,
                authenticationService: mockAuthenticationService,
                localAuthenticationService: mockLocalAuthenticationService,
                analyticsService: mockAnalyticsService,
                completionAction: { },
                handleError: { _ in }
            )
            sut.start(url: nil)
            mockCoordinatorBuilder._signInSuccessCallAction = {
                continuation.resume()
            }
        }

        #expect(!mockAuthenticationService._encryptRefreshTokenCallSuccess)
    }

    @Test
    func authenticationFailure_callsHandleError() async {
        let mockAuthenticationService = MockAuthenticationService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController =  MockNavigationController()

        mockLocalAuthenticationService._stubbedAuthenticationOnboardingSeen = true
        mockLocalAuthenticationService._stubbedLocalAuthenticationEnabled = false
        mockAuthenticationService._stubbedAuthenticationResult = .failure(.genericError)

        let mockAnalyticsService = MockAnalyticsService()
        let newWindow = UIWindow(frame: UIScreen.main.bounds)
        newWindow.rootViewController = mockNavigationController
        newWindow.makeKeyAndVisible()

        var authError: AuthenticationError?
        let completion = await withCheckedContinuation { continuation in
            let sut = AuthenticationCoordinator(
                navigationController: mockNavigationController,
                coordinatorBuilder: MockCoordinatorBuilder.mock,
                authenticationService: mockAuthenticationService,
                localAuthenticationService: mockLocalAuthenticationService,
                analyticsService: mockAnalyticsService,
                completionAction: { continuation.resume(returning: true) },
                handleError: { error in
                    authError = error
                    continuation.resume(returning: false)
                }
            )
            sut.start(url: nil)
        }

        #expect(authError == .genericError)
        #expect(!completion)
    }
}
