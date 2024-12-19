import Foundation

final class CompoundRedactor: Redactor {
    private let redactors: [Redactor]

    init(redactors: [Redactor]) {
        self.redactors = redactors
        super.init()
    }

    override func redact(_ text: String) -> String {
        redactors.reduce(text) { $1.redact($0) }
    }
}
