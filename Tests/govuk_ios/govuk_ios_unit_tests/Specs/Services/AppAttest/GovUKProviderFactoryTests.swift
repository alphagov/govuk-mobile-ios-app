import Testing
import FirebaseCore
import FirebaseAppCheck

@testable import govuk_ios

//struct GovUKProviderFactoryTests {
//
//    @Test
//    func createProvider_withMockApp_returnsExpectedResult() throws {
//        let sut = GovUKProviderFactory()
//        let firebaseApp: FirebaseAppInterface = MockFirebaseApp()
//
//        #expect(sut.createProvider(with: firebaseApp) == nil)
//    }
//}

@Suite
struct EmptyTokenProviderTests {

    @Test
    func getToken_returnsEmptyToken() async {
        let sut = EmptyTokenProvider()
        let token = await withCheckedContinuation { continuation in
            sut.getToken { token, _ in
                continuation.resume(returning: token)
            }
        }
        #expect(token?.token == "")
    }
}
