import Foundation

enum Redactable {
    case email
    case niNumber
    case postCode

    var redactableType: RedactableProviding {
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
