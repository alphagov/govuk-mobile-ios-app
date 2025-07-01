import Testing
import FirebaseAppCheck

@testable import govuk_ios

struct AppAttestServiceTests {

    @Test func token_returns_expected_result() async throws {
        MockAppCheck.appCheck()._stubbedAppCheckToken = AppCheckToken(token: "Token", expirationDate: Date())
        let mockProviderFactory = MockProviderFactory()
        let mockProvider = MockAppCheckProvider()
        mockProviderFactory.provider = mockProvider
        
        let sut = AppAttestService(
            appCheckInterface: MockAppCheck.self,
            providerFactory: MockProviderFactory()
        )
        sut.configure()

        let token = try? await sut.token(forcingRefresh: false)
        #expect(token?.token == "Token")
        MockAppCheck.appCheck()._stubbedAppCheckToken = nil
    }
}

class MockProviderFactory: ProviderFactoryInterface {
    var provider: AppCheckProvider?
    func createProvider(with app: FirebaseAppInterface) -> AppCheckProvider? {
        provider
    }
}

class MockAppCheckProvider: NSObject, AppCheckProvider {
    var _stubbedToken: AppCheckToken?
    func getToken(completion handler: @escaping (AppCheckToken?, Error?) -> Void) {
        handler(_stubbedToken, nil)
    }
}
