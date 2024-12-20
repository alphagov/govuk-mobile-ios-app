import Foundation

struct StringValidator {
    private let validators: [ValidatorProvider]

    init(validators: [ValidatorProvider]) {
        self.validators = validators
    }

    func validate(input: String?) -> Bool {
        return !validators.map { $0.validate(input: input) }.contains(false)
    }
}
