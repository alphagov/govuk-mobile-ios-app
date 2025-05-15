import Foundation

protocol LocalAuthorityServiceInterface {
    func fetchLocalAuthority(postcode: String, completion: @escaping FetchLocalAuthorityCompletion)
    func fetchSavedLocalAuthority() -> [LocalAuthorityItem]
    func fetchLocalAuthority(slug: String, completion: @escaping FetchLocalAuthorityCompletion)
    func fetchLocalAuthorities(
        slugs: [String],
        completion: @escaping (Result<[LocalAuthority], LocalAuthorityError>) -> Void
    )
    func saveLocalAuthority(_ localAuthority: LocalAuthority)
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
            case .success(let authorityType):
                self?.updateLocalAuthority(authorityType)
                completion(.success(authorityType))
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
        completion: @escaping (Result<[LocalAuthority], LocalAuthorityError>) -> Void
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

    private func updateLocalAuthority(_ authorityType: LocalAuthorityType) {
        if let localAuthority = authorityType as? LocalAuthority {
            repository.save(localAuthority)
        }
    }

    func saveLocalAuthority(_ localAuthority: LocalAuthority) {
        repository.save(localAuthority)
    }
}
