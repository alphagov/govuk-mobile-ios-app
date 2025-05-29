import Testing
import FirebaseCore
import FirebaseAppCheck

@testable import govuk_ios

struct GovUKProviderFactoryTests {

    @Test func createProvider_withFirebaseApp_returnsExpectedResult() throws {
        let sut = GovUKProviderFactory()
        let firebaseApp: FirebaseAppInterface = try #require(FirebaseApp.app())
        #expect(sut.createProvider(with: firebaseApp) is AppAttestProvider)
    }

    @Test func createProvider_withMockApp_returnsExpectedResult() throws {
        let sut = GovUKProviderFactory()
        let firebaseApp: FirebaseAppInterface = MockFirebaseApp()
        #expect(sut.createProvider(with: firebaseApp) == nil)
    }
}
