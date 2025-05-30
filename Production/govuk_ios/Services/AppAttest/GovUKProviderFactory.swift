import Foundation
import Firebase
import FirebaseCore
import FirebaseAppCheck

protocol ProviderFactoryInterface {
    func createProvider(with app: any FirebaseAppInterface) -> AppCheckProvider?
}

class GovUKProviderFactory: NSObject, AppCheckProviderFactory, ProviderFactoryInterface {
    func createProvider(with app: any FirebaseAppInterface) -> (any AppCheckProvider)? {
        if let firebaseApp = app as? FirebaseApp {
            return createProvider(with: firebaseApp)
        }
        return nil
    }

    func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
        return AppAttestProvider(app: app)
    }
}
