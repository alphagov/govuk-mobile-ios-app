import Foundation
import UIKit
import Testing
import GOVKit

@testable import govuk_ios

@Suite
struct AuthenticationServiceClientTests {
    @Test @MainActor
    func performAuthenticationFlow_success() async {
        let appAuthSessionWrapper = MockAuthenticationSessionWrapper()
        let oidConfigService = MockOIDConfigService()
        let mockAppEnvironmentService = MockAppEnvironmentService()

        let sut = AuthenticationServiceClient(
            appEnvironmentService: mockAppEnvironmentService,
            appAuthSession: appAuthSessionWrapper,
            oidConfigService: oidConfigService
        )

        await confirmation("Auth request success") { authRequestComplete in
            let result = await sut.performAuthenticationFlow(window: UIApplication.shared.window!)
            if case .success(let tokenResponse) = result {
                let authSessionResponse = appAuthSessionWrapper._mockAuthenticationSession._tokenResponse
                #expect(tokenResponse.accessToken == authSessionResponse.accessToken)
                #expect(tokenResponse.refreshToken == authSessionResponse.refreshToken)
                #expect(tokenResponse.idToken == authSessionResponse.idToken)
                authRequestComplete()
            }
        }
    }

    @Test @MainActor
    func performAuthenticationFlow_failure_loginFlowError() async {
        let appAuthSessionWrapper = MockAuthenticationSessionWrapper()
        let oidConfigService = MockOIDConfigService()
        let mockAppEnvironmentService = MockAppEnvironmentService()
        appAuthSessionWrapper._mockAuthenticationSession._shouldReturnError = true

        let sut = AuthenticationServiceClient(
            appEnvironmentService: mockAppEnvironmentService,
            appAuthSession: appAuthSessionWrapper,
            oidConfigService: oidConfigService
        )

        await confirmation("Auth request failure") { authRequestComplete in
            let result = await sut.performAuthenticationFlow(window: UIApplication.shared.window!)
            if case .failure(let error) = result {
                #expect(error == .loginFlow(.userCancelled))
                authRequestComplete()
            }
        }
    }
}
