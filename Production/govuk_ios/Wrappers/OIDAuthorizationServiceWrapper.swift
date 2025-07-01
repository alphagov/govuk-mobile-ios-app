import Foundation
import AppAuth

protocol OIDAuthorizationServiceWrapperInterface {
    func perform(_ request: OIDTokenRequest, completion: @escaping OIDTokenCallback)
}

class OIDAuthorizationServiceWrapper: OIDAuthorizationServiceWrapperInterface {
    func perform(_ request: OIDTokenRequest, completion: @escaping OIDTokenCallback) {
        OIDAuthorizationService.perform(request, callback: completion)
    }
}
