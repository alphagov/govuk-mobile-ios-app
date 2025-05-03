import Foundation
import AppAuthCore

@testable import govuk_ios

class MockOIDAuthService: OIDAuthorizationServiceWrapperInterface {
    var _shouldReturnError: Bool = false
    func perform(_ request: OIDTokenRequest, completion: @escaping OIDTokenCallback) {
        if _shouldReturnError {
            completion(nil, FakeOIDConfigError.genericError)
        } else {
            completion(tokenRefreshResponse, nil)
        }
    }
    
    var _stubbedAccessToken: String? = UUID().uuidString
    var _stubbedIdToken: String = UUID().uuidString
    var tokenRefreshResponse: OIDTokenResponse {
        let request = OIDTokenRequest(
            configuration: OIDServiceConfiguration(
                authorizationEndpoint: URL(string: "https://example.com/auth")!,
                tokenEndpoint: URL(string: "https://example.com/token")!
            ),
            grantType: OIDGrantTypeRefreshToken,
            authorizationCode: nil,
            redirectURL: nil,
            clientID: "client_id",
            clientSecret: nil,
            scope: nil,
            refreshToken: UUID().uuidString,
            codeVerifier: nil,
            additionalParameters: nil
        )
        var parameters: [String: NSCopying & NSObjectProtocol] = [
            "token_type": "Bearer" as NSString,
            "id_token": _stubbedIdToken as NSString,
            "expires_in": 3600 as NSNumber
        ]
        if _stubbedAccessToken != nil {
            parameters.merge(
                ["access_token": _stubbedAccessToken! as NSString]
            ) { (_, new) in
                new
            }
        }
        return OIDTokenResponse(
            request: request,
            parameters: parameters
        )
    }
}

enum FakeOIDConfigError: Error {
    case genericError
}
