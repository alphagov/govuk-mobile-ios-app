import Foundation

enum ReturningUserServiceError: Error {
    case missingIdentifierError
    case coreDataDeletionError
    case saveIdentifierError
}

extension ReturningUserServiceError {
    var govukErrorCode: String {
        switch self {
        case .missingIdentifierError:
            return "3.0.1"
        case .coreDataDeletionError:
            return "3.0.2"
        case .saveIdentifierError:
            return "3.0.3"
        }
    }
}
