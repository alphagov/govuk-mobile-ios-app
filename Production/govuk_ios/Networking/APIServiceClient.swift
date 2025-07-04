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

enum SigningError: Error {
    case invalidSignature
}

struct APIServiceClient: APIServiceClientInterface {
    private let baseUrl: URL
    private let session: URLSession
    private let requestBuilder: RequestBuilderInterface
    private let responseHandler: ResponseHandler?

    init(baseUrl: URL,
         session: URLSession,
         requestBuilder: RequestBuilderInterface,
         responseHandler: ResponseHandler? = nil) {
        self.baseUrl = baseUrl
        self.session = session
        self.requestBuilder = requestBuilder
        self.responseHandler = responseHandler
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
            signingKey: request.signingKey,
            completion: completion
        )
    }

    private func send(request: URLRequest,
                      signingKey: String?,
                      completion: @escaping NetworkResultCompletion<Data>) {
        let task = session.dataTask(
            with: request,
            completionHandler: { data, response, error in
                let localError = responseHandler?.handleResponse(response,
                                                                 error: error) ?? error
                let result: NetworkResult<Data>
                switch (data, localError) {
                case (_, .some(let error)):
                    result = .failure(error)
                case (.some(let data), _):
                       if verifySignatureIfNecessary(
                            signatureBase64: response?.signature,
                            data: data,
                            signingKey: signingKey
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

    private func verifySignatureIfNecessary(signatureBase64: String?,
                                            data: Data,
                                            signingKey: String?) -> Bool {
        // If no key provided, request doesn't need signing
        guard let signingKey
        else {
            return true
        }

        guard let signatureBase64,
              let signatureData = Data(base64Encoded: signatureBase64)
        else {
            return false
        }

        guard let publicKeyFile = Bundle.main.publicKey(name: signingKey),
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
