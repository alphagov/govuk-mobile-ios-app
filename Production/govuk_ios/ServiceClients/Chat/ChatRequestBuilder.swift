import Foundation

struct ChatRequestBuilder: RequestBuilderInterface {
    private let authenticationToken: String

    init(authenticationToken: String) {
        self.authenticationToken = authenticationToken
    }

    func request(url: URL,
                 method: String,
                 headers: [String: String]?,
                 body: Data?) -> URLRequest {
        var request = URLRequest(url: url)
        var newHeaders = headers ?? [:]
        newHeaders["Authorization"] = "Bearer \(authenticationToken)"
        newHeaders["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = newHeaders
        request.httpMethod = method
        request.httpBody = body
        return request
    }
}
