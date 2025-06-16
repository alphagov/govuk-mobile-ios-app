import Foundation

struct LocalAuthorityResponseHandler: ResponseHandler {
    func handleStatusCode(_ statusCode: Int) -> Error {
        switch statusCode {
        case 400:
            return LocalAuthorityError.invalidPostcode
        case 404:
            return LocalAuthorityError.unknownPostcode
        case 429:
            return LocalAuthorityError.apiUnavailable
        default:
            return LocalAuthorityError.apiUnavailable
        }
    }
}
