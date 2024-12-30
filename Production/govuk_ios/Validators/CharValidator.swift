import Foundation

struct CharValidator: ValidatorProvider {
    func validate(input: String?) -> Bool {
        guard let input = input else { return false }
        let invalidChars: [String] = ["}", "*", "-", "{"]

        return invalidChars.filter { input.contains($0) }.count == 0
    }
}
