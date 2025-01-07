import Foundation

extension Redactor {
    static var pii: Redactor {
        CompoundRedactor(
            redactors: [
                .postcode,
                .email,
                .nino
            ]
        )
    }

    static var postcode: Redactor {
        RegexRedactor(
            pattern: "([A-Za-z]{1,2}[0-9]{1,2}[A-Za-z]? *[0-9][A-Za-z]{2})",
            replacementText: "[postcode]"
        )
    }

    static var email: Redactor {
        RegexRedactor(
            pattern: "[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}",
            replacementText: "[email]"
        )
    }

    static var nino: Redactor {
        RegexRedactor(
            pattern: "[A-Za-z]{2} *[0-9]{2} *[0-9]{2} *[0-9]{2} *[A-Za-z]",
            replacementText: "[NI number]"
        )
    }
}
