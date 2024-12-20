import Foundation

struct CharValidator: ValidatorProvider {
    func validate(input: String?) -> Bool {
        guard let input = input else { return false }
        let invalidChars: [String] = ["}", "*", "-", "{"]

         return invalidChars.filter { char in
            input.contains(char)
         }.count == 0
    }
}
