import Foundation
import Testing

@testable import govuk_ios

struct UserDefaults_ExtensionsTests {

    @Test
    func valueForKey_returnsValue() {
        let sut: UserDefaultsInterface = UserDefaults.standard
        let expectedValue = Data()
        sut.set(expectedValue, forKey: .biometricsPolicyState)

        #expect(sut.value(forKey: .biometricsPolicyState) as? Data == expectedValue)
    }

    @Test
    func remove_removesExpectedValue() throws {
        let sut: UserDefaultsInterface = UserDefaults.standard
        let expectedValue = UUID().uuidString

        sut.set(expectedValue, forKey: .refreshTokenExpiryDate)

        try #require(sut.value(forKey: .refreshTokenExpiryDate) as? String == expectedValue)

        sut.remove(key: .refreshTokenExpiryDate)

        let result = sut.value(forKey: .refreshTokenExpiryDate)
        #expect(result == nil)
    }
}
