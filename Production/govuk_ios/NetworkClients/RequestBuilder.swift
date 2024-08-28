import Foundation

internal protocol RequestBuilderInterface {
    func request(url: URL,
                 method: String,
                 headers: [String: String]?,
                 body: Data?) -> URLRequest
}

internal struct RequestBuilder: RequestBuilderInterface {}

extension RequestBuilderInterface {
    func data(from request: GOVRequest,
              with url: URL) -> URLRequest {
        var data: Data?
        if let params = request.parameters {
            data = try? JSONSerialization.data(
                withJSONObject: params,
                options: .prettyPrinted
            )
        }
        return self.request(
            url: URL(base: url, request: request),
            method: request.method.rawValue,
            headers: request.additionalHeaders,
            body: data
        )
    }

    internal func request(url: URL,
                          method: String,
                          headers: [String: String]?,
                          body: Data?) -> URLRequest {
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = method
        request.httpBody = body
        return request
    }
}
