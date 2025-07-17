import Foundation

struct ChatResponseHandler: ResponseHandler {
    func handleStatusCode(_ statusCode: Int) -> Error {
        switch statusCode {
        case 404:
            ChatError.pageNotFound
        case 422:
            ChatError.validationError
        case 429:
            ChatError.apiUnavailable
        default:
            ChatError.apiUnavailable
        }
    }
}
