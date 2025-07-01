import Foundation
import UIKit
import Testing
import GOVKit

@testable import govuk_ios

@Suite
struct AuthenticationServiceClientTests {
    @Test @MainActor
    func performAuthenticationFlow_success_returnsSuccess() async {
        let appAuthSessionWrapper = MockAuthenticationSessionWrapper()
        let mockOidAuthService = MockOIDAuthService()
        let mockAppEnvironmentService = MockAppEnvironmentService()
        let sut = AuthenticationServiceClient(
            appEnvironmentService: mockAppEnvironmentService,
            appAuthSession: appAuthSessionWrapper,
            oidAuthService: mockOidAuthService,
            revokeTokenServiceClient: MockAPIServiceClient(),
            appAttestService: MockAppAttestService()
        )

        await confirmation() { confirmation in
            let result = await sut.performAuthenticationFlow(window: UIApplication.shared.window!)
            if case .success(let tokenResponse) = result {
                let authSessionResponse = appAuthSessionWrapper._mockAuthenticationSession._tokenResponse
                #expect(tokenResponse.accessToken == authSessionResponse.accessToken)
                #expect(tokenResponse.refreshToken == authSessionResponse.refreshToken)
                #expect(tokenResponse.idToken == authSessionResponse.idToken)
                confirmation()
            }
        }
    }

    @Test @MainActor
    func performAuthenticationFlow_loginFlowError_returnsFailure() async {
        let appAuthSessionWrapper = MockAuthenticationSessionWrapper()
        let mockOidAuthService = MockOIDAuthService()
        let mockAppEnvironmentService = MockAppEnvironmentService()
        appAuthSessionWrapper._mockAuthenticationSession._shouldReturnError = true
        let sut = AuthenticationServiceClient(
            appEnvironmentService: mockAppEnvironmentService,
            appAuthSession: appAuthSessionWrapper,
            oidAuthService: mockOidAuthService,
            revokeTokenServiceClient: MockAPIServiceClient(),
            appAttestService: MockAppAttestService()
        )

        await confirmation() { confirmation in
            let result = await sut.performAuthenticationFlow(window: UIApplication.shared.window!)
            if case .failure(let error) = result {
                #expect(error == .loginFlow(.userCancelled))
                confirmation()
            }
        }
    }

    @Test
    func performTokenRefresh_success_returnsSuccess() async {
        let appAuthSessionWrapper = await MockAuthenticationSessionWrapper()
        let mockOidAuthService = MockOIDAuthService()
        let mockAppEnvironmentService = MockAppEnvironmentService()
        let sut = AuthenticationServiceClient(
            appEnvironmentService: mockAppEnvironmentService,
            appAuthSession: appAuthSessionWrapper,
            oidAuthService: mockOidAuthService,
            revokeTokenServiceClient: MockAPIServiceClient(),
            appAttestService: MockAppAttestService()
        )
        let accessToken = UUID().uuidString
        let idToken = UUID().uuidString
        mockOidAuthService._stubbedAccessToken = accessToken
        mockOidAuthService._stubbedIdToken = idToken

        await confirmation() { confirmation in
            let result = await sut.performTokenRefresh(refreshToken: UUID().uuidString)
            if case .success(let tokenResponse) = result {
                #expect(tokenResponse.accessToken == accessToken)
                #expect(tokenResponse.idToken == idToken)
                confirmation()
            }
        }
    }

    @Test
    func performTokenRefresh_missingAccessToken_returnsFailure() async {
        let appAuthSessionWrapper = await MockAuthenticationSessionWrapper()
        let mockOidAuthService = MockOIDAuthService()
        let mockAppEnvironmentService = MockAppEnvironmentService()
        let sut = AuthenticationServiceClient(
            appEnvironmentService: mockAppEnvironmentService,
            appAuthSession: appAuthSessionWrapper,
            oidAuthService: mockOidAuthService,
            revokeTokenServiceClient: MockAPIServiceClient(),
            appAttestService: MockAppAttestService()
        )
        mockOidAuthService._stubbedAccessToken = nil

        await confirmation() { confirmation in
            let result = await sut.performTokenRefresh(refreshToken: UUID().uuidString)
            if case .failure(let error) = result {
                #expect(error == .missingAccessTokenError)
                confirmation()
            }
        }
    }

    @Test
    func performTokenRefresh_oidAuthServiceError_returnsFailure() async {
        let appAuthSessionWrapper = await MockAuthenticationSessionWrapper()
        let mockOidAuthService = MockOIDAuthService()
        let mockAppEnvironmentService = MockAppEnvironmentService()
        let sut = AuthenticationServiceClient(
            appEnvironmentService: mockAppEnvironmentService,
            appAuthSession: appAuthSessionWrapper,
            oidAuthService: mockOidAuthService,
            revokeTokenServiceClient: MockAPIServiceClient(),
            appAttestService: MockAppAttestService()
        )
        mockOidAuthService._shouldReturnError = true

        await confirmation() { confirmation in
            let result = await sut.performTokenRefresh(refreshToken: UUID().uuidString)
            if case .failure(let error) = result {
                #expect(error == .tokenResponseError)
                confirmation()
            }
        }
    }

    @Test
    func revokeTokenSuccess_callsCompletion() async {
        let appAuthSessionWrapper = await MockAuthenticationSessionWrapper()
        let mockOidAuthService = MockOIDAuthService()
        let mockAppEnvironmentService = MockAppEnvironmentService()
        let mockRevokeTokenClient = MockAPIServiceClient()
        mockRevokeTokenClient._stubbedSendResponse = .success(Data())
        let sut = AuthenticationServiceClient(
            appEnvironmentService: mockAppEnvironmentService,
            appAuthSession: appAuthSessionWrapper,
            oidAuthService: mockOidAuthService,
            revokeTokenServiceClient: mockRevokeTokenClient,
            appAttestService: MockAppAttestService()
        )

        let result = await withCheckedContinuation { continuation in
            sut.revokeToken("token") {
                continuation.resume(returning: true)
            }
        }

        #expect(result)
    }

    @Test
    func revokeTokenFailure_doesNot_callsCompletion() async {
        let appAuthSessionWrapper = await MockAuthenticationSessionWrapper()
        let mockOidAuthService = MockOIDAuthService()
        let mockAppEnvironmentService = MockAppEnvironmentService()
        let mockRevokeTokenClient = MockAPIServiceClient()
        mockRevokeTokenClient._stubbedSendResponse = .failure(TestError.fakeNetwork)
        let sut = AuthenticationServiceClient(
            appEnvironmentService: mockAppEnvironmentService,
            appAuthSession: appAuthSessionWrapper,
            oidAuthService: mockOidAuthService,
            revokeTokenServiceClient: mockRevokeTokenClient,
            appAttestService: MockAppAttestService()
        )

        var didCallCompletion: Bool = false
        let _ = await withCheckedContinuation { continuation in
            sut.revokeToken("token") {
                didCallCompletion = true
            }
            continuation.resume()
        }

        #expect(!didCallCompletion)
    }

    @Test
    func revokeToken_nilToken_doesNot_callsCompletion() async {
        let appAuthSessionWrapper = await MockAuthenticationSessionWrapper()
        let mockOidAuthService = MockOIDAuthService()
        let mockAppEnvironmentService = MockAppEnvironmentService()
        let mockRevokeTokenClient = MockAPIServiceClient()
        mockRevokeTokenClient._stubbedSendResponse = .success(Data())
        let sut = AuthenticationServiceClient(
            appEnvironmentService: mockAppEnvironmentService,
            appAuthSession: appAuthSessionWrapper,
            oidAuthService: mockOidAuthService,
            revokeTokenServiceClient: mockRevokeTokenClient,
            appAttestService: MockAppAttestService()
        )

        var didCallCompletion: Bool = false
        sut.revokeToken(nil) {
            didCallCompletion = true
        }

        #expect(!didCallCompletion)
    }
}
