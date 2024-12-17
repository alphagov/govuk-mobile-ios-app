import Foundation

protocol ValidatorProvidor {
    func validate(input: String) -> Bool
}

struct NonNilValidator: ValidatorProvidor {
    func validate(input: String) -> Bool {
        return !input.isEmpty
    }
}

struct LengthValidator: ValidatorProvidor {
    private let requiredStringLength: Int

    init(requiredStringLength: Int) {
        self.requiredStringLength = requiredStringLength
    }

    func validate(input: String) -> Bool {
        return input.count >= requiredStringLength
    }
}
