import Foundation

class MockURLProtocol: URLProtocol {

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    static var requestHandlers: [String: ((URLRequest) -> (HTTPURLResponse, Data?, Error?)?)] = [:]

    override func startLoading() {
        guard let requestUrl = request.url,
              var components = URLComponents(url: requestUrl, resolvingAgainstBaseURL: true)
        else { fatalError("URL is unavailable.") }

        components.queryItems = nil
        
        guard let url = components.url?.absoluteString,
              let handler = MockURLProtocol.requestHandlers[url]
        else { fatalError("Handler is unavailable.") }

        guard let (response, data, error) = handler(request) else {
            client?.urlProtocolDidFinishLoading(self)
            return
        }

        if let error = error {
            client?.urlProtocol(
                self,
                didFailWithError: error
            )
        } else {
            client?.urlProtocol(
                self,
                didReceive: response,
                cacheStoragePolicy: .notAllowed
            )
        }

        if let data = data {
            client?.urlProtocol(
                self,
                didLoad: data
            )
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
        
    }

}

extension URLSession {
    static var mock: URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        return .init(configuration: config)
    }
}
