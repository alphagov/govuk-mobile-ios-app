import Foundation

enum Redactable {
    case email
    case niNumber
    case postCode

    var redactor: Redactor {
        switch self {
        case .email:
            return Email()
        case .niNumber:
            return NINumber()
        case .postCode:
            return PostCode()
        }
    }
}
