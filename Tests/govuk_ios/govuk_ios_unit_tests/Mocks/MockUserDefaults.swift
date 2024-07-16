import Foundation

class MockUserDefaults: OnboardingPersistanceInterface {
    var userDefaults: [String: Bool] = [:]
    
    func hasOnboarded(forKey key: UserDefaultsKeys) -> Bool {
        return userDefaults[key.rawValue] == true
    }
    
    func setFlag(forkey key: UserDefaultsKeys, to value: Bool) {
        userDefaults[key.rawValue] = value
    }
}
