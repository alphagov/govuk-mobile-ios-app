import Foundation
import Testing

@testable import govuk_ios

struct UserDefaults_ExtensionsTests {

    @Test
    func valueForKey_returnsValue() {
        let sut: UserDefaultsInterface = UserDefaults()
        let expectedValue = "test".data(using: .utf8)
        sut.set(expectedValue, forKey: .biometricsPolicyState)

        #expect(sut.value(forKey: .biometricsPolicyState) as? Data == expectedValue)
    }

    @Test
    func remove_removesExpectedValue() throws {
        let sut: UserDefaultsInterface = UserDefaults()
        let expectedDate = Date.now
        let expectedValue = UUID().uuidString

        sut.set(expectedDate, forKey: .refreshTokenExpiryDate)
        sut.set(expectedValue, forKey: .biometricsPolicyState)

        try #require(sut.value(forKey: .refreshTokenExpiryDate) as? Date == expectedDate)
        try #require(sut.value(forKey: .biometricsPolicyState) as? String == expectedValue)

        sut.removeObject(forKey: .refreshTokenExpiryDate)
        let resultDate = sut.value(forKey: .refreshTokenExpiryDate)
        #expect(resultDate == nil)

        sut.removeObject(forKey: .biometricsPolicyState)

        let resultValue = sut.value(forKey: .biometricsPolicyState)
        #expect(resultValue == nil)
    }
}
