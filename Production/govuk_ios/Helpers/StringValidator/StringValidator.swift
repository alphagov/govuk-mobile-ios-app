import Foundation

struct StringValidator {
    private let validators: [ValidatorProvidor]

    init(validators: [ValidatorProvidor]) {
        self.validators = validators
    }

    func validate(input: String) -> Bool {
        return !validators.map { $0.validate(input: input) }.contains(false)
    }
}
