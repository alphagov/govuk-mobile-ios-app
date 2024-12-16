import Foundation

extension Redactable {
    func redact(text: String) -> String {
        return text.replacingOccurrences(
            of: pattern,
            with: replacementText,
            options: .regularExpression,
            range: nil
        )
    }
}
