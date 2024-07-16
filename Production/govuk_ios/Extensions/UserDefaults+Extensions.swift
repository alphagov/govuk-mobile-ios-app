import Foundation

extension UserDefaults: OnboardingPersistanceInterface {
    func hasOnboarded(forKey key: UserDefaultsKeys) -> Bool {
        return self.bool(forKey: key.rawValue)
    }

    func setFlag(forkey key: UserDefaultsKeys, to value: Bool) {
        self.set(value, forKey: key.rawValue)
    }
}

enum UserDefaultsKeys: String {
  case hasOnboarded
}
