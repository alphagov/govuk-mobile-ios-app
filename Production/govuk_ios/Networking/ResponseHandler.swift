import Foundation

protocol ResponseHandler {
    func handleResponse(_ response: URLResponse?,
                        error: Error?) -> Error?
}

enum HTTPError: Error {
    case badRequest
    case unauthorized
    case notFound
    case unknown
}
