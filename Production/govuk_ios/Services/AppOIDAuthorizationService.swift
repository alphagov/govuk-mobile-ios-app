import Foundation
import AppAuth

protocol AppOIDConfigServiceInterface {
    func discoverConfiguration(
        forIssuer issuer: URL,
        completion: @escaping (OIDServiceConfiguration?, Error?) -> Void
    )
}

class AppOIDConfigService: AppOIDConfigServiceInterface {
    func discoverConfiguration(
        forIssuer issuer: URL,
        completion: @escaping (OIDServiceConfiguration?, Error?) -> Void
    ) {
        OIDAuthorizationService.discoverConfiguration(forIssuer: issuer, completion: completion)
    }
}
