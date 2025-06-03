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
        let mockAuthenticationService = MockAuthenticationService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController =  MockNavigationController()
        mockLocalAuthenticationService._stubbedCanEvaluateBiometricsPolicy = true
        mockLocalAuthenticationService._stubbedAuthenticationOnboardingSeen = true
        mockLocalAuthenticationService._stubbedLocalAuthenticationEnabled = true
        mockAuthenticationService._stubbedAuthenticationResult = .success(
            .init(returningUser: true)
        )
        let newWindow = UIWindow(frame: UIScreen.main.bounds)
        newWindow.rootViewController = mockNavigationController
        newWindow.makeKeyAndVisible()
        let completion = await withCheckedContinuation { continuation in
            let sut = AuthenticationCoordinator(
                navigationController: mockNavigationController,
                coordinatorBuilder: MockCoordinatorBuilder.mock,
                authenticationService: mockAuthenticationService,
                localAuthenticationService: mockLocalAuthenticationService,
                completionAction: { continuation.resume(returning: true) },
                handleError: { _ in }
            )
            sut.start(url: nil)
        }

        #expect(mockAuthenticationService._encryptRefreshTokenCallSuccess)
        #expect(completion)
    }

    @Test
    func start_onboardingFlowNotSeen_shouldntEncryptToken_callsCompletion() async {
        let mockAuthenticationService = MockAuthenticationService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController =  MockNavigationController()
        mockLocalAuthenticationService._stubbedCanEvaluateBiometricsPolicy = true
        mockLocalAuthenticationService._stubbedAuthenticationOnboardingSeen = false
        mockLocalAuthenticationService._stubbedLocalAuthenticationEnabled = false
        mockAuthenticationService._stubbedAuthenticationResult = .success(
            .init(returningUser: true)
        )
        let newWindow = UIWindow(frame: UIScreen.main.bounds)
        newWindow.rootViewController = mockNavigationController
        newWindow.makeKeyAndVisible()
        let completion = await withCheckedContinuation { continuation in
            let sut = AuthenticationCoordinator(
                navigationController: mockNavigationController,
                coordinatorBuilder: MockCoordinatorBuilder.mock,
                authenticationService: mockAuthenticationService,
                localAuthenticationService: mockLocalAuthenticationService,
                completionAction: { continuation.resume(returning: true) },
                handleError: { _ in }
            )
            sut.start(url: nil)
        }

        #expect(!mockAuthenticationService._encryptRefreshTokenCallSuccess)
        #expect(completion)
    }

    @Test
    func start_localAuthenticationEnabled_biometricsEnrolled_shouldEncryptToken_callsCompletion() async {
        let mockAuthenticationService = MockAuthenticationService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController =  MockNavigationController()
        mockLocalAuthenticationService._stubbedCanEvaluateBiometricsPolicy = true
        mockLocalAuthenticationService._stubbedAuthenticationOnboardingSeen = true
        mockLocalAuthenticationService._stubbedLocalAuthenticationEnabled = true
        mockAuthenticationService._stubbedAuthenticationResult = .success(
            .init(returningUser: true)
        )
        let newWindow = UIWindow(frame: UIScreen.main.bounds)
        newWindow.rootViewController = mockNavigationController
        newWindow.makeKeyAndVisible()
        let completion = await withCheckedContinuation { continuation in
            let sut = AuthenticationCoordinator(
                navigationController: mockNavigationController,
                coordinatorBuilder: MockCoordinatorBuilder.mock,
                authenticationService: mockAuthenticationService,
                localAuthenticationService: mockLocalAuthenticationService,
                completionAction: { continuation.resume(returning: true) },
                handleError: { _ in }
            )
            sut.start(url: nil)
        }

        #expect(mockAuthenticationService._encryptRefreshTokenCallSuccess)
        #expect(completion)
    }

    @Test
    func start_localAuthenticationDisabled_shouldntEncryptToken_callsCompletion() async {
        let mockAuthenticationService = MockAuthenticationService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController =  MockNavigationController()
        mockLocalAuthenticationService._stubbedCanEvaluatePasscodePolicy = true
        mockLocalAuthenticationService._stubbedAuthenticationOnboardingSeen = true
        mockLocalAuthenticationService._stubbedLocalAuthenticationEnabled = false
        mockAuthenticationService._stubbedAuthenticationResult = .success(
            .init(returningUser: true)
        )
        let newWindow = UIWindow(frame: UIScreen.main.bounds)
        newWindow.rootViewController = mockNavigationController
        newWindow.makeKeyAndVisible()
        let completion = await withCheckedContinuation { continuation in
            let sut = AuthenticationCoordinator(
                navigationController: mockNavigationController,
                coordinatorBuilder: MockCoordinatorBuilder.mock,
                authenticationService: mockAuthenticationService,
                localAuthenticationService: mockLocalAuthenticationService,
                completionAction: { continuation.resume(returning: true) },
                handleError: { _ in }
            )
            sut.start(url: nil)
        }

        #expect(!mockAuthenticationService._encryptRefreshTokenCallSuccess)
        #expect(completion)
    }

    @Test
    func start_passcodeEnrolled_shouldEncryptToken_callsCompletion() async {
        let mockAuthenticationService = MockAuthenticationService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController =  MockNavigationController()
        mockLocalAuthenticationService._stubbedCanEvaluatePasscodePolicy = true
        mockLocalAuthenticationService._stubbedAuthenticationOnboardingSeen = true
        mockLocalAuthenticationService._stubbedLocalAuthenticationEnabled = true
        mockAuthenticationService._stubbedAuthenticationResult = .success(
            .init(returningUser: true)
        )
        let newWindow = UIWindow(frame: UIScreen.main.bounds)
        newWindow.rootViewController = mockNavigationController
        newWindow.makeKeyAndVisible()

        let completion = await withCheckedContinuation { continuation in
            let sut = AuthenticationCoordinator(
                navigationController: mockNavigationController,
                coordinatorBuilder: MockCoordinatorBuilder.mock,
                authenticationService: mockAuthenticationService,
                localAuthenticationService: mockLocalAuthenticationService,
                completionAction: { continuation.resume(returning: true) },
                handleError: { _ in }
            )
            sut.start(url: nil)
        }

        #expect(mockAuthenticationService._encryptRefreshTokenCallSuccess)
        #expect(completion)
    }

    @Test
    func authenticationFailure_callsHandleError() async {
        let mockAuthenticationService = MockAuthenticationService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockNavigationController =  MockNavigationController()

        mockLocalAuthenticationService._stubbedCanEvaluatePasscodePolicy = true
        mockLocalAuthenticationService._stubbedAuthenticationOnboardingSeen = true
        mockLocalAuthenticationService._stubbedLocalAuthenticationEnabled = false
        mockAuthenticationService._stubbedAuthenticationResult = .failure(.genericError)
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
