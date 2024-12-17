import Foundation

struct StringValidator {
    private let validators: [ValidatorProvidor]

    init(validators: [ValidatorProvidor]) {
        self.validators = validators
    }

    func validate(input: String) -> Bool {
        var results: [Bool] = []
        results = validators.map { $0.validate(input: input) }
        return !results.contains(false)
    }
}
