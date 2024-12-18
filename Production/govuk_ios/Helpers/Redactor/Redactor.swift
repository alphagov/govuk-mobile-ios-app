import Foundation

struct CompoundRedactor {
    private let redactables: [Redactable]

    init(redactables: [Redactable]) {
        self.redactables = redactables
    }

    func redact(inputText: String) -> String {
        var text = inputText
        redactables.forEach { redactable in
            text = redactable.redactor.redact(from: text)
        }
        return text
    }
}
