import Foundation

struct Redactor {
    private let redactables: [Redactables]

    init(redactables: [Redactables]) {
        self.redactables = redactables
    }

    func redact(inputText: String) -> String {
        var text = inputText
        redactables.forEach { redactable in
            text = redactable.fetchRedactable.redact(text: text)
        }
        return text
    }
}
