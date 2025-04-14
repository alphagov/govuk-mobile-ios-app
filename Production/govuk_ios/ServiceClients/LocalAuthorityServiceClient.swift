import Foundation

typealias FetchLocalServiceCompletion = (sending FetchLocalServiceResult) -> Void
typealias FetchLocalServiceResult = Result<LocalAuthorityType, LocalServiceError>

protocol LocalAuthorityServiceClientInterface {
    func fetchLocalAuthority(postcode: String, completion: @escaping FetchLocalServiceCompletion)
}

enum LocalServiceError: LocalizedError {
    case networkUnavailable
    case apiUnavailable
    case decodingError
}

struct LocalAuthorityServiceClient: LocalAuthorityServiceClientInterface {
    private let serviceClient: APIServiceClientInterface

    init(serviceClient: APIServiceClientInterface) {
        self.serviceClient = serviceClient
    }

    func fetchLocalAuthority(postcode: String,
                    completion: @escaping FetchLocalServiceCompletion) {
        serviceClient.send(request: .localAuthority(postcode: postcode)) { result  in
            completion(mapResult(result))
        }
    }

    private func mapResult(
        _ result: NetworkResult<Data>) -> Result<LocalAuthorityType, LocalServiceError> {
            return result.mapError { error in
                let nsError = (error as NSError)
                if nsError.code == NSURLErrorNotConnectedToInternet {
                    return LocalServiceError.networkUnavailable
                } else {
                    return LocalServiceError.apiUnavailable
                }
            }.flatMap {
                do {
                    guard let response = decode(data: $0) else {
                        return .failure(LocalServiceError.decodingError)
                    }
                    return .success(response)
                }
            }
        }

    private func decode(data: Data) -> LocalAuthorityType? {
        if let localAuthority = try? JSONDecoder().decode(LocalAuthority.self, from: data) {
            return localAuthority
        }
        if let addressList = try? JSONDecoder().decode(LocalAuthoritiesList.self, from: data) {
            return addressList
        }
        if let errorMessage = try? JSONDecoder().decode(LocalErrorMessage.self, from: data) {
            return errorMessage
        }
        return nil
    }
}

protocol LocalAuthorityType { }

