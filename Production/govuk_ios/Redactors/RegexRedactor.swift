import Foundation

class RegexRedactor: Redactor {
    private let pattern: String
    private let replacementText: String

    init(pattern: String,
         replacementText: String = "[redacted]") {
        self.pattern = pattern
        self.replacementText = replacementText
    }

    override func redact(_ text: String) -> String {
        text.replacingOccurrences(
            of: pattern,
            with: replacementText,
            options: .regularExpression
        )
    }
}
