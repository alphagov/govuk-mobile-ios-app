import Foundation

protocol ValidatorProvider {
    func validate(input: String?) -> Bool
}
