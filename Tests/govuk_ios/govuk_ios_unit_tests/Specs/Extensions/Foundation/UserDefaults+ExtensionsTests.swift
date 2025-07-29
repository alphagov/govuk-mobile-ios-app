import Foundation
import Testing

@testable import govuk_ios

struct UserDefaults_ExtensionsTests {

    @Test
    func test_valueForKey_returnsValue() {
        let sut: UserDefaultsInterface = UserDefaults.standard
        let expectedValue = Data()
        sut.set(expectedValue, forKey: .biometricsPolicyState)

        #expect(sut.value(forKey: .biometricsPolicyState) as? Data == expectedValue)
    }
}
