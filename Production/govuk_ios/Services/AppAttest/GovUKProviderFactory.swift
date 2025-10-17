import Foundation
import Firebase
import FirebaseCore
import FirebaseAppCheck

class GovUKProviderFactory: NSObject,
                            AppCheckProviderFactory {
    func createProvider(with app: FirebaseApp) -> (any AppCheckProvider)? {
        #if STAGING
        return EmptyTokenProvider()
        #else
        return AppAttestProvider(app: app)
        #endif
    }
}

class EmptyTokenProvider: NSObject,
                          AppCheckProvider {
    func getToken(completion: @escaping (AppCheckToken?, Error?) -> Void) {
        completion(.init(token: "", expirationDate: .distantFuture), nil)
    }
}
