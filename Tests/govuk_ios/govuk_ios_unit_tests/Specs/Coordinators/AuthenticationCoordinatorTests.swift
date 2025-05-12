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
        let jsonData = """
        {
            "accessToken": "access_token",
            "refreshToken": "refresh_token",
            "idToken": "id_token",
            "tokenType": "id_token",
            "expiryDate": "2099-01-01T00:00:00Z"
        }
        """.data(using: .utf8)!
        let tokenResponse = createTokenResponse(jsonData)
        mockLocalAuthenticationService._stubbedCanEvaluateBiometricsPolicy = true
        mockAuthenticationService.authenticationOnboardingFlowSeen = true
        mockAuthenticationService.isLocalAuthenticationSkipped = false
        mockAuthenticationService._stubbedAuthenticationResult = .success(tokenResponse)
        let newWindow = UIWindow(frame: UIScreen.main.bounds)
        newWindow.rootViewController = mockNavigationController
        newWindow.makeKeyAndVisible()

        let completion = await withCheckedContinuation { continuation in
            let sut = AuthenticationCoordinator(
                navigationController: mockNavigationController,
                authenticationService: mockAuthenticationService,
                localAuthenticationService: mockLocalAuthenticationService,
                coordinatorBuilder: MockCoordinatorBuilder.mock,
                completionAction: { continuation.resume(returning: true) },
                handleError: { _ in }
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
        let jsonData = """
        {
            "accessToken": "access_token",
            "refreshToken": "refresh_token",
            "idToken": "id_token",
            "tokenType": "id_token",
            "expiryDate": "2099-01-01T00:00:00Z"
        }
        """.data(using: .utf8)!
        let tokenResponse = createTokenResponse(jsonData)
        mockLocalAuthenticationService._stubbedCanEvaluateBiometricsPolicy = true
        mockAuthenticationService.authenticationOnboardingFlowSeen = false
        mockAuthenticationService.isLocalAuthenticationSkipped = false
        mockAuthenticationService._stubbedAuthenticationResult = .success(tokenResponse)
        let newWindow = UIWindow(frame: UIScreen.main.bounds)
        newWindow.rootViewController = mockNavigationController
        newWindow.makeKeyAndVisible()

        let completion = await withCheckedContinuation { continuation in
            let sut = AuthenticationCoordinator(
                navigationController: mockNavigationController,
                authenticationService: mockAuthenticationService,
                localAuthenticationService: mockLocalAuthenticationService,
                coordinatorBuilder: MockCoordinatorBuilder.mock,
                completionAction: { continuation.resume(returning: true) },
                handleError: { _ in }
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
        let jsonData = """
        {
            "accessToken": "access_token",
            "refreshToken": "refresh_token",
            "idToken": "id_token",
            "tokenType": "id_token",
            "expiryDate": "2099-01-01T00:00:00Z"
        }
        """.data(using: .utf8)!
        let tokenResponse = createTokenResponse(jsonData)
        mockLocalAuthenticationService._stubbedCanEvaluateBiometricsPolicy = true
        mockAuthenticationService.authenticationOnboardingFlowSeen = true
        mockAuthenticationService.isLocalAuthenticationSkipped = true
        mockAuthenticationService._stubbedAuthenticationResult = .success(tokenResponse)
        let newWindow = UIWindow(frame: UIScreen.main.bounds)
        newWindow.rootViewController = mockNavigationController
        newWindow.makeKeyAndVisible()

        let completion = await withCheckedContinuation { continuation in
            let sut = AuthenticationCoordinator(
                navigationController: mockNavigationController,
                authenticationService: mockAuthenticationService,
                localAuthenticationService: mockLocalAuthenticationService,
                coordinatorBuilder: MockCoordinatorBuilder.mock,
                completionAction: { continuation.resume(returning: true) },
                handleError: { _ in }
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
        let jsonData = """
        {
            "accessToken": "access_token",
            "refreshToken": "refresh_token",
            "idToken": "id_token",
            "tokenType": "id_token",
            "expiryDate": "2099-01-01T00:00:00Z"
        }
        """.data(using: .utf8)!
        let tokenResponse = createTokenResponse(jsonData)
        mockLocalAuthenticationService._stubbedCanEvaluatePasscodePolicy = true
        mockAuthenticationService.authenticationOnboardingFlowSeen = false
        mockAuthenticationService.isLocalAuthenticationSkipped = true
        mockAuthenticationService._stubbedAuthenticationResult = .success(tokenResponse)
        let newWindow = UIWindow(frame: UIScreen.main.bounds)
        newWindow.rootViewController = mockNavigationController
        newWindow.makeKeyAndVisible()

        let completion = await withCheckedContinuation { continuation in
            let sut = AuthenticationCoordinator(
                navigationController: mockNavigationController,
                authenticationService: mockAuthenticationService,
                localAuthenticationService: mockLocalAuthenticationService,
                coordinatorBuilder: MockCoordinatorBuilder.mock,
                completionAction: { continuation.resume(returning: true) },
                handleError: { _ in }
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
        let jsonData = """
        {
            "accessToken": "access_token",
            "refreshToken": "refresh_token",
            "idToken": "id_token",
            "tokenType": "id_token",
            "expiryDate": "2099-01-01T00:00:00Z"
        }
        """.data(using: .utf8)!
        let tokenResponse = createTokenResponse(jsonData)
        mockLocalAuthenticationService._stubbedCanEvaluatePasscodePolicy = true
        mockAuthenticationService.authenticationOnboardingFlowSeen = true
        mockAuthenticationService.isLocalAuthenticationSkipped = false
        mockAuthenticationService._stubbedAuthenticationResult = .success(tokenResponse)
        let newWindow = UIWindow(frame: UIScreen.main.bounds)
        newWindow.rootViewController = mockNavigationController
        newWindow.makeKeyAndVisible()

        let completion = await withCheckedContinuation { continuation in
            let sut = AuthenticationCoordinator(
                navigationController: mockNavigationController,
                authenticationService: mockAuthenticationService,
                localAuthenticationService: mockLocalAuthenticationService,
                coordinatorBuilder: MockCoordinatorBuilder.mock,
                completionAction: { continuation.resume(returning: true) },
                handleError: { _ in }
            )
            sut.start(url: nil)
        }

        #expect(mockAuthenticationService._encryptRefreshTokenCallSuccess)
        #expect(completion)
    }

    @Test @MainActor
    func authenticationFailure_callsHandleError() async {
        let mockAuthenticationService = MockAuthenticationService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController =  MockNavigationController()

        mockLocalAuthenticationService._stubbedCanEvaluatePasscodePolicy = true
        mockAuthenticationService.authenticationOnboardingFlowSeen = true
        mockAuthenticationService.isLocalAuthenticationSkipped = false
        mockAuthenticationService._stubbedAuthenticationResult = .failure(.genericError)
        let newWindow = UIWindow(frame: UIScreen.main.bounds)
        newWindow.rootViewController = mockNavigationController
        newWindow.makeKeyAndVisible()

        var authError: AuthenticationError?
        let completion = await withCheckedContinuation { continuation in
            let sut = AuthenticationCoordinator(
                navigationController: mockNavigationController,
                authenticationService: mockAuthenticationService,
                localAuthenticationService: mockLocalAuthenticationService,
                coordinatorBuilder: MockCoordinatorBuilder.mock,
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

    private func createTokenResponse(_ jsonData: Data) -> TokenResponse {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let tokenResponse = try? decoder.decode(TokenResponse.self, from: jsonData)
        return tokenResponse!
    }
}
