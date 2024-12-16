import Foundation

protocol Redactable {
    var pattern: String { get }
    var replacementText: String { get }
}

struct PostCode: Redactable {
    var replacementText: String = "[postcode]"
    var pattern: String = "([A-Za-z]{1,2}[0-9]{1,2}[A-Za-z]? *[0-9][A-Za-z]{2})"
}

struct Email: Redactable {
    var replacementText: String = "[email]"
    var pattern: String = "[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
}

struct NINumber: Redactable {
    var replacementText: String = "[NI number]"
    var pattern: String = "[A-Za-z]{2} *[0-9]{2} *[0-9]{2} *[0-9]{2} *[A-Za-z]"
}
