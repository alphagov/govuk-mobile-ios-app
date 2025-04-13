import Foundation

protocol LocalAuthorityServiceInterface {
    func fetchLocal(postcode: String, completion: @escaping FetchLocalServiceCompletion)
}

class LocalAuthorityService: LocalAuthorityServiceInterface {
    private let serviceClient: LocalAuthorityServiceClientInterface

    init(serviceClient: LocalAuthorityServiceClientInterface) {
        self.serviceClient = serviceClient
    }

    func fetchLocal(postcode: String, completion: @escaping FetchLocalServiceCompletion) {
        serviceClient.fetchLocal(postcode: postcode) { result in
            completion(result)
        }
    }
}
