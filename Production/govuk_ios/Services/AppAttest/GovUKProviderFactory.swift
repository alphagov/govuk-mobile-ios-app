import Foundation
import Firebase
import FirebaseCore
import FirebaseAppCheck

class GovUKProviderFactory: NSObject,
                            AppCheckProviderFactory {
    func createProvider(with app: FirebaseApp) -> (any AppCheckProvider)? {
        return AppCheckDebugProvider(app: app)
        #if DEBUG
        #else
        return AppAttestProvider(app: app)
        #endif
    }
}
