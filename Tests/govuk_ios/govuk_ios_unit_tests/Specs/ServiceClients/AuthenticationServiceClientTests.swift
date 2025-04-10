import Foundation
import Testing

@testable import govuk_ios

@Suite
struct AuthenticationServiceClientTests {
    @Test @MainActor
    func performAuthenticationFlow_success() async {
        let appConfig = MockAppConfigService()
        let appAuthSession = MockAuthenticationSession()
        let oidConfigService = MockOIDConfigService()

        let sut = AuthenticationServiceClient(
            appConfig: appConfig,
            appAuthSession: appAuthSession,
            oidConfigService: oidConfigService
        )

        await confirmation("Auth request success") { authRequestComplete in
            await sut.performAuthenticationFlow { result in
                if case .success(let tokenResponse) = result {
                    #expect(tokenResponse.accessToken == appAuthSession._tokenResponse.accessToken)
                    #expect(tokenResponse.refreshToken == appAuthSession._tokenResponse.refreshToken)
                    #expect(tokenResponse.idToken == appAuthSession._tokenResponse.idToken)
                    authRequestComplete()
                }
            }
        }
    }

    @Test @MainActor
    func performAuthenticationFlow_failure_loginFlowError() async {
        let appConfig = MockAppConfigService()
        let appAuthSession = MockAuthenticationSession()
        let oidConfigService = MockOIDConfigService()
        appAuthSession._shouldReturnError = true

        let sut = AuthenticationServiceClient(
            appConfig: appConfig,
            appAuthSession: appAuthSession,
            oidConfigService: oidConfigService
        )

        await confirmation("Auth request failure") { authRequestComplete in
            await sut.performAuthenticationFlow { result in
                if case .failure(let error) = result {
                    #expect(error == .loginFlow(.userCancelled))
                    authRequestComplete()
                }
            }
        }
    }

    @Test @MainActor
    func performAuthenticationFlow_failure_fetchConfigError() async {
        let appConfig = MockAppConfigService()
        let appAuthSession = MockAuthenticationSession()
        let oidConfigService = MockOIDConfigService()
        oidConfigService._shouldReturnFetchConfigError = true

        let sut = AuthenticationServiceClient(
            appConfig: appConfig,
            appAuthSession: appAuthSession,
            oidConfigService: oidConfigService
        )

        await confirmation("Auth request failure") { authRequestComplete in
            await sut.performAuthenticationFlow { result in
                if case .failure(let error) = result {
                    #expect(error == .fetchConfigError)
                    authRequestComplete()
                }
            }
        }
    }
}
