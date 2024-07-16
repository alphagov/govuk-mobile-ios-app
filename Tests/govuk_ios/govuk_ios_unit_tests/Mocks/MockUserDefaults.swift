import Foundation

class MockUserDefaults: OnboardingPersistanceInterface {
    
    var userDefaults: [String: Bool] = [UserDefaultsKeys.hasOnboarded.rawValue:true]
    
    
    
    func checkIfHasOnBoarded(forKey key: UserDefaultsKeys) -> Bool {
        print("mock instance")
        if userDefaults[key.rawValue] == true  {
            return true
        } else {
            return false
        }
    }
    
    func setFlag(forkey key: UserDefaultsKeys, to value: Bool) {
        userDefaults[key.rawValue] = value
    }
}
