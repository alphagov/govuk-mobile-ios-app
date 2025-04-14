import Foundation

protocol LocalAuthorityServiceInterface {
    func fetchLocalAuthority(postcode: String, completion: @escaping FetchLocalAuthorityCompletion)
}

class LocalAuthorityService: LocalAuthorityServiceInterface {
    private let serviceClient: LocalAuthorityServiceClientInterface

    init(serviceClient: LocalAuthorityServiceClientInterface) {
        self.serviceClient = serviceClient
    }

    func fetchLocalAuthority(postcode: String,
                             completion: @escaping FetchLocalAuthorityCompletion) {
        serviceClient.fetchLocalAuthority(postcode: postcode) { result in
            completion(result)
        }
    }
}
