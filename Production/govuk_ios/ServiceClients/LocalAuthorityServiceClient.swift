import Foundation

typealias FetchLocalAuthorityCompletion = (sending FetchLocalAuthorityResult) -> Void
typealias FetchLocalAuthorityResult = Result<LocalAuthorityType, LocalAuthorityError>

protocol LocalAuthorityServiceClientInterface {
    func fetchLocalAuthority(postcode: String, completion: @escaping FetchLocalAuthorityCompletion)

    func fetchLocalAuthority(
        slug: String,
        completion: @escaping FetchLocalAuthorityCompletion
    )
    func fetchLocalAuthorities(
        slugs: [String],
        completion: @escaping (Result<[LocalAuthority], LocalAuthorityError>) -> Void
    )
}

enum LocalAuthorityError: LocalizedError {
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
                             completion: @escaping FetchLocalAuthorityCompletion) {
        serviceClient.send(request: .localAuthority(postcode: postcode)) { result in
            completion(mapResult(result))
        }
    }

    func fetchLocalAuthority(
        slug: String,
        completion: @escaping FetchLocalAuthorityCompletion) {
        serviceClient.send(request: .localAuthoritySlug(slug: slug)) { result in
            completion(mapResult(result))
        }
    }

    func fetchLocalAuthorities(
        slugs: [String],
        completion: @escaping (Result<[LocalAuthority], LocalAuthorityError>) -> Void) {
            var results: [LocalAuthority?] = []
            var localAuthError: LocalAuthorityError?
            let group = DispatchGroup()

            for slug in slugs {
                group.enter()
                fetchLocalAuthority(slug: slug) { result in
                    switch result {
                    case .success(let localAuthority):
                        results.append(localAuthority as? LocalAuthority)
                    case .failure(let error):
                        localAuthError = error
                    }
                    group.leave()
                }
            }

            group.notify(queue: .main) {
                if let localAuthError {
                    completion(.failure(localAuthError))
                } else {
                    completion(.success(results.compactMap { $0 }))
                }
            }
    }

    private func mapResult(
        _ result: NetworkResult<Data>) -> Result<LocalAuthorityType, LocalAuthorityError> {
            return result.mapError { error in
                let nsError = (error as NSError)
                if nsError.code == NSURLErrorNotConnectedToInternet {
                    return LocalAuthorityError.networkUnavailable
                } else {
                    return LocalAuthorityError.apiUnavailable
                }
            }.flatMap {
                do {
                    guard let response = decode(data: $0) else {
                        return .failure(LocalAuthorityError.decodingError)
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
