import Foundation

struct RegexValidator: ValidatorProvider {
    private let regex: String

    init(_ regex: String) {
        self.regex = regex
    }

    func validate(input: String?) -> Bool {
        return input?.range(
            of: regex,
            options: .regularExpression
        ) != nil
    }
}
