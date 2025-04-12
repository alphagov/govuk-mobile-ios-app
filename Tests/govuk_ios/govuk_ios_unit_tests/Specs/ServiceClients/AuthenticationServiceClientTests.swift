import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
struct AuthenticationServiceClientTests {
    @Test @MainActor
    func performAuthenticationFlow_success() async {
        let appConfig = MockAppConfigService()
        let appAuthSessionWrapper = MockAuthenticationSessionWrapper()
        let oidConfigService = MockOIDConfigService()

        let sut = AuthenticationServiceClient(
            appConfig: appConfig,
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
        let appConfig = MockAppConfigService()
        let appAuthSessionWrapper = MockAuthenticationSessionWrapper()
        let oidConfigService = MockOIDConfigService()
        appAuthSessionWrapper._mockAuthenticationSession._shouldReturnError = true

        let sut = AuthenticationServiceClient(
            appConfig: appConfig,
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

    @Test @MainActor
    func performAuthenticationFlow_failure_fetchConfigError() async {
        let appConfig = MockAppConfigService()
        let appAuthSessionWrapper = MockAuthenticationSessionWrapper()
        let oidConfigService = MockOIDConfigService()
        oidConfigService._shouldReturnFetchConfigError = true

        let sut = AuthenticationServiceClient(
            appConfig: appConfig,
            appAuthSession: appAuthSessionWrapper,
            oidConfigService: oidConfigService
        )

        await confirmation("Auth request failure") { authRequestComplete in
            let result = await sut.performAuthenticationFlow(window: UIApplication.shared.window!)
            if case .failure(let error) = result {
                #expect(error == .fetchConfigError)
                authRequestComplete()
            }
        }
    }
}
