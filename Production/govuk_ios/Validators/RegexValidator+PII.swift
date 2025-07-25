import Foundation

extension RegexValidator {
    static var pii: ValidatorProvider {
        CompoundRegexValidator(
            validators: [
                phoneNumber,
                creditCard,
                email,
                nationalInsuranceNumber
            ]
        )
    }

    static var phoneNumber: RegexValidator {
        RegexValidator(
            "(?:\\+?([0-9]{1,3}))? ?[-.(]?([0-9]{3,5})?[-.)]? ?([0-9]{3})[-. ]?([0-9]{3,4})"
        )
    }

    static var creditCard: RegexValidator {
        RegexValidator(
            "[0-9]{13,16}|[0-9]{4} [0-9]{4} [0-9]{4} [0-9]{4}|[0-9]{4} [0-9]{6} [0-9]{5}"
        )
    }

    static var email: RegexValidator {
        RegexValidator(
            "[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        )
    }

    static var nationalInsuranceNumber: RegexValidator {
        RegexValidator(
            "[A-Za-z]{2} ?([0-9 ]+){6,8} ?[A-Za-z]"
        )
    }
}
