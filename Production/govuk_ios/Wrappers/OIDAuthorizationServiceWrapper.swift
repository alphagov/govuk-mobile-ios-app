import Foundation
import AppAuth

protocol OIDAuthorizationServiceWrapperInterface {
    func discoverConfiguration(
        forIssuer issuer: URL,
        completion: @escaping (OIDServiceConfiguration?, Error?) -> Void
    )
}

class OIDAuthorizationServiceWrapper: OIDAuthorizationServiceWrapperInterface {
    func discoverConfiguration(
        forIssuer issuer: URL,
        completion: @escaping (OIDServiceConfiguration?, Error?) -> Void
    ) {
        OIDAuthorizationService.discoverConfiguration(forIssuer: issuer, completion: completion)
    }
}
