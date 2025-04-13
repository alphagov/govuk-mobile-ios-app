import Foundation

import Foundation

@testable import govuk_ios

class MockLocalServiceClient: LocalAuthorityServiceClientInterface {
    var _stubbedPostcode: String?
    var _stubbedLocalResult: Result<LocalAuthorityType, LocalServiceError>?
    var _receivedLocalCompletion: FetchLocalServiceCompletion?
    func fetchLocal(postcode: String, completion: @escaping FetchLocalServiceCompletion) {
        _stubbedPostcode = postcode
        if let result = _stubbedLocalResult {
            completion(result)
        }
    }
}
