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

    var _stubbedFetchLocalPostcodeResult: FetchLocalAuthorityResult?
    func fetchLocalAuthority(postcode: String, completion: @escaping FetchLocalAuthorityCompletion) {
        if let result = _stubbedFetchLocalPostcodeResult {
            completion(result)
        }
    }

    var _stubbedFetchLocalSlugResult: FetchLocalAuthorityResult?
    func fetchLocalAuthority(slug: String, completion: @escaping FetchLocalAuthorityCompletion) {
        if let result = _stubbedFetchLocalSlugResult {
            completion(result)
        }
    }

    var _stubbedLocalAuthoritiesResult: Result<[Authority], govuk_ios.LocalAuthorityError>?
    func fetchLocalAuthorities(slugs: [String], completion: @escaping (Result<[Authority], LocalAuthorityError>) -> Void) {
        if let result = _stubbedLocalAuthoritiesResult {
            completion(result)
        }
    }

    var _savedAuthority: Authority?
    func saveLocalAuthority(_ localAuthority: Authority) {
        _savedAuthority = localAuthority
    }
}

