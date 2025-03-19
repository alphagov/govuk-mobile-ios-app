import Foundation

struct MinimumLengthValidator: ValidatorProvider {
    private let length: Int

    init(length: Int) {
        self.length = length
    }

    func validate(input: String?) -> Bool {
        guard let input = input else { return false }
        return input.count >= length
    }
}
