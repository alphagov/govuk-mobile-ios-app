import Foundation
import AppAuthCore

@testable import govuk_ios

class MockOIDConfigService: AppOIDConfigServiceInterface {
    var _shouldReturnFetchConfigError: Bool = false
    func discoverConfiguration(forIssuer issuer: URL, completion: @escaping (OIDServiceConfiguration?, Error?) -> Void) {
        if _shouldReturnFetchConfigError {
            completion(nil, FakeConfigError.genericError)
        } else {
            let config = OIDServiceConfiguration(
                authorizationEndpoint: URL(string: "https://example.com/auth")!,
                tokenEndpoint: URL(string: "https://example.com/token")!
            )
            completion(config, nil)
        }
    }
}

enum FakeConfigError: Error {
    case genericError
}
