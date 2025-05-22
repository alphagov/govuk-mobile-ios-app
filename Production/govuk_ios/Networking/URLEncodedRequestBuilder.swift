import Foundation

struct URLEncodedRequestBuilder: RequestBuilderInterface {
    func data(from request: GOVRequest,
              with url: URL) -> URLRequest {
        var data: Data?
        if let params = request.bodyParameters {
            var urlEncodedComponents = URLComponents()
            urlEncodedComponents.queryItems = params.map {
                URLQueryItem(
                    name: $0.key,
                    value: String(describing: $0.value)
                )
            }
            data = urlEncodedComponents.percentEncodedQuery?.data(using: .utf8)
        }

        return self.request(
            url: URL(base: url, request: request),
            method: request.method.rawValue,
            headers: request.additionalHeaders,
            body: data
        )
    }
}
