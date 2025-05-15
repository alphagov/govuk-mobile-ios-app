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

    var _stubbedLocalAuthoritiesResult: Result<[govuk_ios.LocalAuthority], govuk_ios.LocalAuthorityError>?
    func fetchLocalAuthorities(slugs: [String], completion: @escaping (Result<[govuk_ios.LocalAuthority], govuk_ios.LocalAuthorityError>) -> Void) {
        if let result = _stubbedLocalAuthoritiesResult {
            completion(result)
        }
    }

    var _stubbedSaveLocalAuthorityCalled = false
    func saveLocalAuthority(_ localAuthority: LocalAuthority) {
        _stubbedSaveLocalAuthorityCalled = true
    }
}

