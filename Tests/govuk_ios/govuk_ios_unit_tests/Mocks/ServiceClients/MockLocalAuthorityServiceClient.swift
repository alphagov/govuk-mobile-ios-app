import Foundation

@testable import govuk_ios

class MockLocalServiceClient: LocalAuthorityServiceClientInterface {
    var _stubbedPostcode: String?
    var _stubbedLocalPostcodeResult: Result<LocalAuthorityType, LocalAuthorityError>?
    var _receivedLocalCompletion: FetchLocalAuthorityCompletion?
    func fetchLocalAuthority(postcode: String, completion: @escaping FetchLocalAuthorityCompletion) {
        _stubbedPostcode = postcode
        if let result = _stubbedLocalPostcodeResult {
            completion(result)
        }
    }

    var _stubbedSlug: String?
    var _stubbedLocalSlugResult: Result<LocalAuthorityType, LocalAuthorityError>?
    func fetchLocalAuthority(slug: String, completion: @escaping FetchLocalAuthorityCompletion) {
        _stubbedSlug = slug
        if let result = _stubbedLocalSlugResult {
            completion(result)
        }
    }

    var _stubbedSlugs: [String]?
    var _stubbedLocalAuthoritiesResult: Result<[LocalAuthority], LocalAuthorityError>?
    func fetchLocalAuthorities(slugs: [String],
                               completion: @escaping (Result<[LocalAuthority], LocalAuthorityError>) -> Void) {
        _stubbedSlugs = slugs
        if let result =  _stubbedLocalAuthoritiesResult {
            completion(result)
        }
    }
}
