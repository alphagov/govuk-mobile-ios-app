import Foundation

struct CompoundRegexValidator: ValidatorProvider {
    private let validators: [ValidatorProvider]

    init(validators: [ValidatorProvider]) {
        self.validators = validators
    }

    func validate(input: String?) -> Bool {
        validators.contains(where: { $0.validate(input: input) })
    }
}
