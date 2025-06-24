import Foundation

struct ChatResponseHandler: ResponseHandler {
    func handleStatusCode(_ statusCode: Int) -> Error {
        switch statusCode {
        case 422:
            ChatError.validationError
        case 429:
            ChatError.apiUnavailable
        default:
            ChatError.apiUnavailable
        }
    }
}
