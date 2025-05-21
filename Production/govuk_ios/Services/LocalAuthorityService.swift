import Foundation

protocol LocalAuthorityServiceInterface {
    func fetchLocalAuthority(postcode: String, completion: @escaping FetchLocalAuthorityCompletion)
    func fetchSavedLocalAuthority() -> [LocalAuthorityItem]
    func fetchLocalAuthority(slug: String, completion: @escaping FetchLocalAuthorityCompletion)
    func fetchLocalAuthorities(
        slugs: [String],
        completion: @escaping (Result<[Authority], LocalAuthorityError>) -> Void
    )
    func saveLocalAuthority(_ localAuthority: Authority)
}

class LocalAuthorityService: LocalAuthorityServiceInterface {
    private let serviceClient: LocalAuthorityServiceClientInterface
    private let repository: LocalAuthorityRepositoryInterface

    init(serviceClient: LocalAuthorityServiceClientInterface,
         repository: LocalAuthorityRepositoryInterface) {
        self.serviceClient = serviceClient
        self.repository = repository
    }

    func fetchLocalAuthority(postcode: String,
                             completion: @escaping FetchLocalAuthorityCompletion) {
        serviceClient.fetchLocalAuthority(postcode: postcode) { [weak self] result in
            switch result {
            case .success(let response):
                self?.updateLocalAuthority(response)
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchSavedLocalAuthority() -> [LocalAuthorityItem] {
        repository.fetchLocalAuthority()
    }

    func fetchLocalAuthority(slug: String,
                             completion: @escaping FetchLocalAuthorityCompletion) {
        serviceClient.fetchLocalAuthority(slug: slug) { result in
            switch result {
            case .success(let authority):
                completion(.success(authority))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchLocalAuthorities(
        slugs: [String],
        completion: @escaping (Result<[Authority], LocalAuthorityError>) -> Void
    ) {
        serviceClient.fetchLocalAuthorities(slugs: slugs) { result in
            switch result {
            case .success(let authorities):
                completion(.success(authorities))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func updateLocalAuthority(_ response: LocalAuthorityResponse) {
        if let localAuthority = response.localAuthority {
            repository.save(localAuthority)
        }
    }

    func saveLocalAuthority(_ localAuthority: Authority) {
        repository.save(localAuthority)
    }
}
