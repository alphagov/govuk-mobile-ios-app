import Foundation

protocol OnboardingPersistanceInterface {
    func checkIfHasOnBoarded(forKey key: UserDefaultsKeys) -> Bool
    func setFlag(forkey key: UserDefaultsKeys, to value: Bool)
}
