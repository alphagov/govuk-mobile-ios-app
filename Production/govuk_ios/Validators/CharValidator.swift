import Foundation

struct CharValidator: ValidatorProvider {
    func validate(input: String?) -> Bool {
        guard let input = input else { return false }
        return input.range(
            of: ".*[^A-Za-z0-9].*",
            options: .regularExpression
        ) == nil
    }
}
