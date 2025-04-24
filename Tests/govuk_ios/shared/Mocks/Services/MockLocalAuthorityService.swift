import Foundation

@testable import govuk_ios

class MockLocalAuthorityService: LocalAuthorityServiceInterface {

    var _stubbedFetchLocalResult: FetchLocalAuthorityResult?
    func fetchLocalAuthority(postcode: String, completion: @escaping FetchLocalAuthorityCompletion) {
        if let result = _stubbedFetchLocalResult {
            completion(result)
        }
    }
}

