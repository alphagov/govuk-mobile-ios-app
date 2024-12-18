import Foundation

protocol ValidatorProvider {
    func validate(input: String) -> Bool
}

struct NonNilValidator: ValidatorProvider {
    func validate(input: String) -> Bool {
        return !input.isEmpty
    }
}

struct MaximumLengthValidator: ValidatorProvider {
    private let requiredStringLength: Int

    init(requiredStringLength: Int) {
        self.requiredStringLength = requiredStringLength
    }

    func validate(input: String) -> Bool {
        return input.count <= requiredStringLength
    }
}

struct MinimumLengthValidator: ValidatorProvider {
    private let requiredStringLength: Int

    init(requiredStringLength: Int) {
        self.requiredStringLength = requiredStringLength
    }

    func validate(input: String) -> Bool {
        return input.count >= requiredStringLength
    }
}

struct CharValidator: ValidatorProvider {

    func validate(input: String) -> Bool {
        let text = input.trimmingCharacters(in: .whitespacesAndNewlines)
        let regex = ".*[^A-Za-z0-9].*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: input)
    }
}
