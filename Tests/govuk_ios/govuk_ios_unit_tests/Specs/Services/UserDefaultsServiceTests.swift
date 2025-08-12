import Foundation
import Testing

@testable import govuk_ios

struct UserDefaultsServiceTests {

    @Test
    func setValueForKey_setsExpectedValue() {
        let mockUserDefaults = MockUserDefaults()
        let sut = UserDefaultsService(userDefaults: mockUserDefaults)
        let expectedValue = "test".data(using: .utf8)
        sut.set(expectedValue, forKey: .biometricsPolicyState)

        #expect(mockUserDefaults._receivedSetValueKey == UserDefaultsKeys.biometricsPolicyState.rawValue)
        #expect(mockUserDefaults._receivedSetValueValue as? Data == expectedValue)
        #expect(mockUserDefaults._synchronizeCalled)
    }

    @Test
    func valueForKey_returnsExpectedValue() {
        let mockUserDefaults = MockUserDefaults()
        let sut = UserDefaultsService(userDefaults: mockUserDefaults)
        let expectedValue = UUID().uuidString
        mockUserDefaults._stubbedValues = [UserDefaultsKeys.biometricsPolicyState.rawValue: expectedValue]

        #expect(sut.value(forKey: .biometricsPolicyState) as? String == expectedValue)
    }

    @Test
    func setBoolForKey_setsExpectedValue() {
        let mockUserDefaults = MockUserDefaults()
        let sut = UserDefaultsService(userDefaults: mockUserDefaults)
        let expectedValue = UUID().uuidString
        mockUserDefaults._stubbedValues = [UserDefaultsKeys.biometricsPolicyState.rawValue: expectedValue]

        sut.set(bool: true, forKey: .biometricsPolicyState)

        #expect(mockUserDefaults._receivedSetValueValue as? Bool == true)
        #expect(mockUserDefaults._receivedSetValueKey == UserDefaultsKeys.biometricsPolicyState.rawValue)
        #expect(mockUserDefaults._synchronizeCalled)
    }

    @Test
    func boolForKey_returnsExpectedValue() {
        let mockUserDefaults = MockUserDefaults()
        let sut = UserDefaultsService(userDefaults: mockUserDefaults)

        mockUserDefaults._stubbedBoolValues = [
            UserDefaultsKeys.biometricsPolicyState.rawValue: true
        ]

        #expect(sut.bool(forKey: .biometricsPolicyState))
        #expect(sut.bool(forKey: .acceptedAnalytics) == false)
    }

    @Test
    func remove_removesExpectedValue() throws {
        let mockUserDefaults = MockUserDefaults()
        let sut = UserDefaultsService(userDefaults: mockUserDefaults)

        sut.removeObject(forKey: .refreshTokenExpiryDate)
        #expect(mockUserDefaults._receivedRemoveObjectForKeyKey == UserDefaultsKeys.refreshTokenExpiryDate.rawValue)
        #expect(mockUserDefaults._synchronizeCalled)

        mockUserDefaults._synchronizeCalled = false

        sut.removeObject(forKey: .biometricsPolicyState)

        #expect(mockUserDefaults._receivedRemoveObjectForKeyKey == UserDefaultsKeys.biometricsPolicyState.rawValue)
        #expect(mockUserDefaults._synchronizeCalled)
    }
}
