import Foundation

struct ChatResponseHandler: ResponseHandler {
    func handleStatusCode(_ statusCode: Int) -> Error {
        switch statusCode {
        case 401, 403:
            ChatError.authenticationError
        case 404:
            ChatError.pageNotFound
        case 422:
            ChatError.validationError
        default:
            ChatError.apiUnavailable
        }
    }
}
