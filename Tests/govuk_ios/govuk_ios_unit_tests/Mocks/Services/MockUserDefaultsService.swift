import Foundation

@testable import govuk_ios

class MockUserDefaultsService: UserDefaultsServiceInterface {
    func deleteAll() {
        store = [:]
    }

    private(set) var store: [String?: Any] = [:]

    func value(forKey key: UserDefaultsKeys) -> Any? {
        store[key.rawValue]
    }

    func set(_ value: Any?, forKey key: govuk_ios.UserDefaultsKeys) {
        store[key.rawValue] = value
    }

    func bool(forKey key: UserDefaultsKeys) -> Bool {
        (store[key.rawValue] as? Bool) ?? false
    }

    func set(bool boolValue: Bool,
             forKey key: UserDefaultsKeys) {
        store[key.rawValue] = boolValue
    }

    func _stub(value: Any?,
               key: String) {
        store[key] = value
    }

    func removeObject(forKey key: UserDefaultsKeys) {
        store[key.rawValue] = nil
    }
}
