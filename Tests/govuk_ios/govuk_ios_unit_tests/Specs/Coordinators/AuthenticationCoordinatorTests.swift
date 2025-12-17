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
        let mockTopicsService = MockTopicsService()
        let mockChatService = MockChatService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController =  MockNavigationController()
        mockLocalAuthenticationService._stubbedCanEvaluateBiometricsPolicy = true
        mockLocalAuthenticationService.setLocalAuthenticationOnboarded()
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
                topicsService: mockTopicsService,
                chatService: mockChatService,
                completionAction: { },
                errorAction: { _ in }
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
        let mockTopicsService = MockTopicsService()
        let mockChatService = MockChatService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController =  MockNavigationController()
        mockLocalAuthenticationService._stubbedCanEvaluateBiometricsPolicy = true
        mockLocalAuthenticationService._stubbedAuthenticationOnboardingSeen = false
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
                topicsService: mockTopicsService,
                chatService: mockChatService,
                completionAction: { },
                errorAction: { _ in }
            )
            sut.start(url: nil)
            mockCoordinatorBuilder._signInSuccessCallAction = {
                continuation.resume()
            }
        }

        #expect(mockSignInSuccessCoordinator._startCalled)
        #expect(mockAnalyticsService._setExistingConsentCalled)
    }

    @Test
    func signinSuccess_newUser_resetsConsentAndPreferences() async {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockSignInSuccessCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedSignInSuccessCoordinator = mockSignInSuccessCoordinator
        let mockAuthenticationService = MockAuthenticationService()
        let mockTopicsService = MockTopicsService()
        let mockChatService = MockChatService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController =  MockNavigationController()
        mockLocalAuthenticationService._stubbedCanEvaluateBiometricsPolicy = true
        mockLocalAuthenticationService._stubbedAuthenticationOnboardingSeen = false
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
                topicsService: mockTopicsService,
                chatService: mockChatService,
                completionAction: { },
                errorAction: { _ in }
            )
            sut.start(url: nil)
            mockCoordinatorBuilder._signInSuccessCallAction = {
                continuation.resume()
            }
        }

        #expect(mockAnalyticsService._resetConsentCalled)
        #expect(!mockAnalyticsService._setExistingConsentCalled)
        #expect(mockTopicsService._resetOnboardingCalled)
    }

    @Test
    func signinSuccess_returningUser_keepsConsentAndPreferences() async {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockSignInSuccessCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedSignInSuccessCoordinator = mockSignInSuccessCoordinator
        let mockAuthenticationService = MockAuthenticationService()
        let mockTopicsService = MockTopicsService()
        let mockChatService = MockChatService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController =  MockNavigationController()
        mockLocalAuthenticationService._stubbedCanEvaluateBiometricsPolicy = true
        mockLocalAuthenticationService._stubbedAuthenticationOnboardingSeen = false
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
                topicsService: mockTopicsService,
                chatService: mockChatService,
                completionAction: { },
                errorAction: { _ in }
            )
            sut.start(url: nil)
            mockCoordinatorBuilder._signInSuccessCallAction = {
                continuation.resume()
            }
        }

        #expect(!mockAnalyticsService._resetConsentCalled)
        #expect(!mockTopicsService._resetOnboardingCalled)
    }

    @Test
    func signinSuccessCompletion_completesCoordinator() async {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockSignInCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedSignInSuccessCoordinator = mockSignInCoordinator
        let mockAuthenticationService = MockAuthenticationService()
        let mockTopicsService = MockTopicsService()
        let mockChatService = MockChatService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController =  MockNavigationController()
        mockLocalAuthenticationService._stubbedCanEvaluateBiometricsPolicy = true
        mockLocalAuthenticationService._stubbedAuthenticationOnboardingSeen = false
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
                topicsService: mockTopicsService,
                chatService: mockChatService,
                completionAction: { continuation.resume(returning: true) },
                errorAction: { _ in }
            )
            sut.start(url: nil)
            mockCoordinatorBuilder._signInSuccessCallAction = {
                mockCoordinatorBuilder._receivedSignInSuccessCompletion?()
            }
        }

        #expect(completion)
    }

    @Test
    func start_authenticationOnboardingSeen_biometricsEnrolled_shouldEncryptToken_encryptsRefreshToken() async {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockAuthenticationService = MockAuthenticationService()
        let mockTopicsService = MockTopicsService()
        let mockChatService = MockChatService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController =  MockNavigationController()
        mockLocalAuthenticationService._stubbedCanEvaluateBiometricsPolicy = true
        mockLocalAuthenticationService._stubbedAuthenticationOnboardingSeen = true
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
                topicsService: mockTopicsService,
                chatService: mockChatService,
                completionAction: { },
                errorAction: { _ in }
            )
            sut.start(url: nil)
            mockCoordinatorBuilder._signInSuccessCallAction = {
                continuation.resume()
            }
        }

        #expect(mockAuthenticationService._encryptRefreshTokenCallSuccess)
    }

    @Test
    func start_authenticationOnboardingNotSeen_shouldntEncryptToken_doesntEncryptRefreshToken() async {
        let mockAuthenticationService = MockAuthenticationService()
        let mockTopicsService = MockTopicsService()
        let mockChatService = MockChatService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockNavigationController =  MockNavigationController()
        mockLocalAuthenticationService._stubbedAuthenticationOnboardingSeen = false
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
                topicsService: mockTopicsService,
                chatService: mockChatService,
                completionAction: { },
                errorAction: { _ in }
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
        let mockTopicsService = MockTopicsService()
        let mockChatService = MockChatService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController =  MockNavigationController()

        mockLocalAuthenticationService._stubbedAuthenticationOnboardingSeen = true
        mockAuthenticationService._stubbedAuthenticationResult = .failure(.unknown(TestError.anyError))

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
                topicsService: mockTopicsService,
                chatService: mockChatService,
                completionAction: { continuation.resume(returning: true) },
                errorAction: { error in
                    authError = error
                    continuation.resume(returning: false)
                }
            )
            sut.start(url: nil)
        }

        #expect(authError == .unknown(TestError.anyError))
        #expect(!completion)
    }
}
