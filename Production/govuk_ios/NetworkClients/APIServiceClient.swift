import Foundation

import Alamofire

public typealias NetworkResult<T> = Result<T, Error>
public typealias ResponseCompletion<T> = (NetworkResult<T>) -> Void

protocol SessionInterface {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void
    ) -> URLSessionDataTask
}

extension URLSession: SessionInterface {}

struct APIServiceClient {
    private let baseUrl: URL
    private let session: SessionInterface
    private let requestBuilder: RequestBuilderInterface

    init(baseUrl: URL,
         session: SessionInterface,
         requestBuilder: RequestBuilderInterface) {
        self.baseUrl = baseUrl
        self.session = session
        self.requestBuilder = requestBuilder
    }
}

extension APIServiceClient {
    func send(request: GOVRequest,
              completion: @escaping ResponseCompletion<Data>) {
        let urlRequest = requestBuilder.data(
            from: request,
            with: baseUrl
        )
        send(
            request: urlRequest,
            completion: completion
        )
    }

    private func send(request: URLRequest,
                      completion: @escaping ResponseCompletion<Data>) {
        let task = session.dataTask(
            with: request,
            completionHandler: { data, _, error in
                let result: NetworkResult<Data>
                switch (data, error) {
                case (_, .some(let error)):
                    result = .failure(error)
                case (.some(let data), _):
                    result = .success(data)
                case (.none, _):
                    result = .success(Data())
                }
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        )
        task.resume()
    }
}
