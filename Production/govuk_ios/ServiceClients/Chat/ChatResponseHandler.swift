import Foundation

struct ChatResponseHandler: ResponseHandler {
    func handleStatusCode(_ statusCode: Int) -> Error {
        switch statusCode {
        case 422:
            return ChatError.validationError
        case 429:
            return ChatError.apiUnavailable
        default:
            return ChatError.apiUnavailable
        }
    }
}
