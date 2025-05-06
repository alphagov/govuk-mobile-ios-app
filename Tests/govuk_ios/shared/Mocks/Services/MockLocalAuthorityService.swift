import Foundation

@testable import govuk_ios

class MockLocalAuthorityService: LocalAuthorityServiceInterface {

    var _stubbedLocalAuthority: [LocalAuthorityItem]?
    func fetchSavedLocalAuthority() -> [LocalAuthorityItem] {
        if let result = _stubbedLocalAuthority {
            return result
        }
        return []
    }


    var _stubbedFetchLocalResult: FetchLocalAuthorityResult?
    func fetchLocalAuthority(postcode: String, completion: @escaping FetchLocalAuthorityCompletion) {
        if let result = _stubbedFetchLocalResult {
            completion(result)
        }
    }
}

