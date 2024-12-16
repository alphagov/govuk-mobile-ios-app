import Foundation

enum Redactables {
    case email
    case niNumber
    case postCode

    var fetchRedactable: Redactable {
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
