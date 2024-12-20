import Foundation

protocol ValidatorProvider {
    func validate(input: String?) -> Bool
}

struct MaximumLengthValidator: ValidatorProvider {
    private let length: Int

    init(length: Int) {
        self.length = length
    }

    func validate(input: String?) -> Bool {
        guard let input = input else { return false }
        return input.count <= length
    }
}

struct MinimumLengthValidator: ValidatorProvider {
    private let requiredStringLength: Int

    init(requiredStringLength: Int) {
        self.requiredStringLength = requiredStringLength
    }

    func validate(input: String?) -> Bool {
        guard let input = input else { return false }
        return input.count >= requiredStringLength
    }
}

struct CharValidator: ValidatorProvider {
    func validate(input: String?) -> Bool {
        guard let input = input else { return false }
        return input.range(
            of: ".*[^A-Za-z0-9].*",
            options: .regularExpression
        ) == nil
    }
}
