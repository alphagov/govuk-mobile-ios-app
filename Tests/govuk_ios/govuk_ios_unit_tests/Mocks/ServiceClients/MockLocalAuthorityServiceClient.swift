import Foundation

@testable import govuk_ios

class MockLocalServiceClient: LocalAuthorityServiceClientInterface {
    var _stubbedPostcode: String?
    var _stubbedLocalResult: Result<LocalAuthorityType, LocalAuthorityError>?
    var _receivedLocalCompletion: FetchLocalServiceCompletion?
    func fetchLocalAuthority(postcode: String, completion: @escaping FetchLocalServiceCompletion) {
        _stubbedPostcode = postcode
        if let result = _stubbedLocalResult {
            completion(result)
        }
    }
}
