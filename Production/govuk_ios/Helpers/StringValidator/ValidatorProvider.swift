import Foundation

protocol ValidatorProvider {
    func validate(input: String) -> Bool
}

struct NonNilValidator: ValidatorProvider {
    func validate(input: String) -> Bool {
        return !input.isEmpty
    }
}

struct LengthValidator: ValidatorProvider {
    private let requiredStringLength: Int

    init(requiredStringLength: Int) {
        self.requiredStringLength = requiredStringLength
    }

    func validate(input: String) -> Bool {
        return input.count >= requiredStringLength
    }
}
