import Testing

import Firebase
import FirebaseAppCheck

@testable import govuk_ios

struct AppAttestServiceTests {

    @Test
    func token_returns_expected_result() async throws {
        let mockAppCheckProvider = MockAppCheck()
        mockAppCheckProvider._stubbedToken = AppCheckToken(
            token: "Token",
            expirationDate: .distantFuture
        )

        let sut = AppAttestService(
            appCheckInterface: mockAppCheckProvider
        )

        let token = try? await sut.token()
        #expect(token?.token == "Token")
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
