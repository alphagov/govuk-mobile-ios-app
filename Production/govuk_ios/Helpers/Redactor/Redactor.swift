import Foundation

struct Redactor {
    private let redactables: [Redactable]

    init(redactables: [Redactable]) {
        self.redactables = redactables
    }

    func redact(inputText: String) -> String {
        var text = inputText
        redactables.forEach { redactable in
            text = redactable.redactableType.redacted(text: text)
        }
        return text
    }
}
