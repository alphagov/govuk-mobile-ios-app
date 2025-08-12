import Foundation

@testable import govuk_ios

class MockUserDefaults: UserDefaults {
    var _setValueCalled: Bool = false
    var _receivedSetValueValue: Any?
    var _receivedSetValueKey: String?
    override func set(_ value: Any?,
                      forKey defaultName: String) {
        _setValueCalled = true
        _receivedSetValueValue = value
        _receivedSetValueKey = defaultName
    }

    var _synchronizeCalled: Bool = false
    override func synchronize() -> Bool {
        _synchronizeCalled = true
        return true
    }

    var _receivedRemoveObjectForKeyKey: String?
    override func removeObject(forKey defaultName: String) {
        _receivedRemoveObjectForKeyKey = defaultName
    }

    var _stubbedBoolValues: [String: Bool]?
    override func bool(forKey defaultName: String) -> Bool {
        _stubbedBoolValues?[defaultName] ?? false
    }

    var _stubbedValues: [String: Any?]?
    override func value(forKey key: String) -> Any? {
        _stubbedValues?[key] as Any?
    }
}
