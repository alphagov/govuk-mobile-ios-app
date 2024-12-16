import Foundation

extension RedactableProviding {
    func redacted(text: String) -> String {
        return text.replacingOccurrences(
            of: pattern,
            with: replacementText,
            options: .regularExpression,
            range: nil
        )
    }
}
