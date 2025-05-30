import Foundation
import FirebaseCore
import FirebaseAppCheck

protocol AppAttestServiceInterface {
    func token(forcingRefresh: Bool) async throws -> AppCheckToken
    func configure()
}

class AppAttestService: NSObject, AppAttestServiceInterface {
    private let appCheckInterface: AppCheckInterface.Type
    private let providerFactory: ProviderFactoryInterface

    init(appCheckInterface: AppCheckInterface.Type,
         providerFactory: ProviderFactoryInterface) {
        self.appCheckInterface = appCheckInterface
        self.providerFactory = providerFactory
    }

    func configure() {
        // Should be possible to remove this once we have dev environments
        // that do not require attestation.  In the meantime, you can run on
        // the simulator with attestation by following directions here:
        // https://firebase.google.com/docs/app-check/ios/debug-provider?_gl=1*1xyxcyq*_up*MQ..*_ga*MzA4NzA0NTY5LjE3NDg1MDYxMDc.*_ga_CW55HF8NVT*czE3NDg1MDYxMDYkbzEkZzAkdDE3NDg1MDYxMDYkajYwJGwwJGgw
        #if targetEnvironment(simulator)
        let debugFactory = AppCheckDebugProviderFactory()
        appCheckInterface.setAppCheckProviderFactory(debugFactory)
        #else
        appCheckInterface.setAppCheckProviderFactory(providerFactory)
        #endif
    }

    func token(forcingRefresh: Bool) async throws -> AppCheckToken {
        try await appCheckInterface.appCheck().token(forcingRefresh: forcingRefresh)
    }
}

protocol AppCheckInterface {
    static func setAppCheckProviderFactory(_ factory: ProviderFactoryInterface?)
    static func appCheck() -> Self
    func token(forcingRefresh: Bool) async throws -> AppCheckToken
}

extension AppCheck: AppCheckInterface {
    static func setAppCheckProviderFactory(_ factory: ProviderFactoryInterface?) {
        Self.setAppCheckProviderFactory(factory as? AppCheckProviderFactory)
    }
}

extension AppCheckDebugProviderFactory: ProviderFactoryInterface {
    func createProvider(with app: any FirebaseAppInterface) -> AppCheckProvider? {
        if let firebaseApp = app as? FirebaseApp {
            return AppCheckDebugProvider(app: firebaseApp)
        }
        return nil
    }
}
