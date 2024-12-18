import Foundation

protocol Redactor {
    var pattern: String { get }
    var replacementText: String { get }

    func redact(from text: String) -> String
}

struct PostCode: Redactor {
    var replacementText: String = "[postcode]"
    var pattern: String = "([A-Za-z]{1,2}[0-9]{1,2}[A-Za-z]? *[0-9][A-Za-z]{2})"
}

struct Email: Redactor {
    var replacementText: String = "[email]"
    var pattern: String = "[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
}

struct NINumber: Redactor {
    var replacementText: String = "[NI number]"
    var pattern: String = "[A-Za-z]{2} *[0-9]{2} *[0-9]{2} *[0-9]{2} *[A-Za-z]"
}

extension Redactor {
    func redact(from text: String) -> String {
        text.replacingOccurrences(
            of: pattern,
            with: replacementText,
            options: .regularExpression,
            range: nil
        )
    }
}
