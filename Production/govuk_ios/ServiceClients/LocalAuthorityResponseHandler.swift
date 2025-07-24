import Foundation

struct LocalAuthorityResponseHandler: ResponseHandler {
    func handleStatusCode(_ statusCode: Int) -> Error {
        switch statusCode {
        case 400:
            LocalAuthorityError.invalidPostcode
        case 404:
            LocalAuthorityError.unknownPostcode
        case 429:
            LocalAuthorityError.apiUnavailable
        default:
            LocalAuthorityError.apiUnavailable
        }
    }
}
