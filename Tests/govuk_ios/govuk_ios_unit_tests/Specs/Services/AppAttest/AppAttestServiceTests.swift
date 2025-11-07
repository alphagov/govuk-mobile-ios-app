import Testing

import Firebase
import FirebaseAppCheck

@testable import GOVKit
@testable import govuk_ios

@Suite
struct AppAttestServiceTests {

    @Test
    func token_returns_expected_result() async throws {
        let mockAppCheckProvider = MockAppCheck()
        mockAppCheckProvider._stubbedToken = AppCheckToken(
            token: "Token",
            expirationDate: .distantFuture
        )

        let mockAnalyticsService = MockAnalyticsService()
        let sut = AppAttestService(
            appCheckInterface: mockAppCheckProvider,
            analyticsService: mockAnalyticsService
        )

        let token = try? await sut.token()
        #expect(token?.token == "Token")
    }

    @Test
    func token_throwing_tracksError() async throws {
        let mockAppCheckProvider = MockAppCheck()
        mockAppCheckProvider._stubbedTokenError = AppAttestError.tokenGeneration

        let mockAnalyticsService = MockAnalyticsService()
        let sut = AppAttestService(
            appCheckInterface: mockAppCheckProvider,
            analyticsService: mockAnalyticsService
        )

        await #expect(throws: AppAttestError.tokenGeneration) {
            try await sut.token()
        }
    }
}

@Suite
struct AppAttestErrorTests {
    @Test(arguments: zip(
        [
            AppAttestError.tokenGeneration
        ],
        [
            "4.0.1"
        ]
    ))
    func govukErrorCode_returnsExpectedValue(error: AppAttestError,
                                             expectedCode: String) {
        #expect(error.govukErrorCode == expectedCode)
    }
}

class MockProviderFactory: NSObject,
                           AppCheckProviderFactory {
    var _stubbedProvider: AppCheckProvider?
    func createProvider(with app: FirebaseApp) -> (any AppCheckProvider)? {
        _stubbedProvider
    }
}

class MockAppCheckProvider: NSObject,
                            AppCheckProvider {
    var _stubbedToken: AppCheckToken?
    func getToken(completion handler: @escaping (AppCheckToken?, Error?) -> Void) {
        handler(_stubbedToken, nil)
    }
}
