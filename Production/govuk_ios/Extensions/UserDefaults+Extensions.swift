import Foundation

extension UserDefaults: OnboardingPersistanceInterface {
    func checkIfHasOnBoarded(forKey key: UserDefaultsKeys) -> Bool {
        let flag =  self.bool(forKey: key.rawValue)
        return flag
    }

    func setFlag(forkey key: UserDefaultsKeys, to value: Bool) {
        self.set(value, forKey: key.rawValue)
    }
}

enum UserDefaultsKeys: String {
  case hasOnboarded
}
