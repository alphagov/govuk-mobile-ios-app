import Foundation

public typealias NetworkResult<T> = Result<T, Error>
public typealias NetworkResultCompletion<T> = (NetworkResult<T>) -> Void

protocol APIServiceClientInterface {
    func send(
        request: GOVRequest, completion: @escaping NetworkResultCompletion<Data>
    )
}

struct APIServiceClient: APIServiceClientInterface {
    private let baseUrl: URL
    private let session: URLSession
    private let requestBuilder: RequestBuilderInterface

    init(baseUrl: URL,
         session: URLSession,
         requestBuilder: RequestBuilderInterface) {
        self.baseUrl = baseUrl
        self.session = session
        self.requestBuilder = requestBuilder
    }
}

extension APIServiceClient {
    func send(request: GOVRequest,
              completion: @escaping NetworkResultCompletion<Data>) {
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
                      completion: @escaping NetworkResultCompletion<Data>) {
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
