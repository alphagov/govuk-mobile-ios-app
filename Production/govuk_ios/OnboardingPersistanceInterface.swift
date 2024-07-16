import Foundation

protocol OnboardingPersistanceInterface {
    func hasOnboarded(forKey key: UserDefaultsKeys) -> Bool
    func setFlag(forkey key: UserDefaultsKeys, to value: Bool)
}
