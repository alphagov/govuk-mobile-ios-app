import Foundation
import CryptoKit

public typealias NetworkResult<T> = Result<T, Error>
public typealias NetworkResultCompletion<T> = (NetworkResult<T>) -> Void

protocol APIServiceClientInterface {
    func send(
        request: GOVRequest,
        completion: @escaping NetworkResultCompletion<Data>
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
            requiresSignature: request.requiresSignature,
            completion: completion
        )
    }

    private func send(request: URLRequest,
                      requiresSignature: Bool,
                      completion: @escaping NetworkResultCompletion<Data>) {
        let task = session.dataTask(
            with: request,
            completionHandler: { data, response, error in
                let result: NetworkResult<Data>
                switch (data, error) {
                case (_, .some(let error)):
                    result = .failure(error)
                case (.some(let data), _):
                    if !requiresSignature ||
                        verifySignature(
                            signatureBase64: response?.signature,
                            data: data
                        ) {
                        result = .success(data)
                    } else {
                        result = .failure(SigningError.invalidSignature)
                    }
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

    private func verifySignature(signatureBase64: String?, data: Data) -> Bool {
        guard let signatureBase64,
              let signatureData = Data(base64Encoded: signatureBase64)
        else {
            return false
        }

        guard let publicKeyFile = Bundle.main.publicKey,
              let publicKey = try? P256.Signing.PublicKey(derRepresentation: publicKeyFile)
        else {
            return false
        }

        guard let signatureKey = try? P256.Signing.ECDSASignature(derRepresentation: signatureData)
        else {
            return false
        }

        return publicKey.isValidSignature(signatureKey, for: data)
    }
}

extension URLResponse {
    var signature: String? {
        (self as? HTTPURLResponse)?
            .allHeaderFields["x-amz-meta-govuk-sig"] as? String
    }
}
