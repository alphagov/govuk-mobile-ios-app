import Foundation

protocol LocalAuthorityServiceInterface {
    func fetchLocalAuthority(postcode: String, completion: @escaping FetchLocalAuthorityCompletion)
    func fetchSavedLocalAuthority() -> [LocalAuthorityItem]
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

    private func updateLocalAuthority(_ authorityType: LocalAuthorityType) {
        if let localAuthority = authorityType as? LocalAuthority {
            repository.save(localAuthority)
        }
    }
}
