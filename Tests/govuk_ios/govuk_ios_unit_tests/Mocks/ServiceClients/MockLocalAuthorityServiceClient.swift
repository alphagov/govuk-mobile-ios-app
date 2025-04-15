import Foundation

@testable import govuk_ios

class MockLocalServiceClient: LocalAuthorityServiceClientInterface {
    var _stubbedPostcode: String?
    var _stubbedLocalResult: Result<LocalAuthorityType, LocalAuthorityError>?
    var _receivedLocalCompletion: FetchLocalAuthorityCompletion?
    func fetchLocalAuthority(postcode: String, completion: @escaping FetchLocalAuthorityCompletion) {
        _stubbedPostcode = postcode
        if let result = _stubbedLocalResult {
            completion(result)
        }
    }
}
