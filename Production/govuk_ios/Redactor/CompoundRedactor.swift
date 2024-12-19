import Foundation

final class CompoundRedactor: Redactor {
    private let redactors: [Redactor]

    init(redactors: [Redactor]) {
        self.redactors = redactors
        super.init()
    }

    override func redact(_ text: String) -> String {
        var text = text
        redactors.forEach { redactor in
            text = redactor.redact(text)
        }
        return text
    }
}
