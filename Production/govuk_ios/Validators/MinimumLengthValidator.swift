import Foundation

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
