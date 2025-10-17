import Foundation
import Firebase
import FirebaseCore
import FirebaseAppCheck

protocol AppAttestServiceInterface {
    func token() async throws -> AppCheckToken
}

class AppAttestService: NSObject,
                        AppAttestServiceInterface {
    private let appCheckInterface: AppCheckInterface

    init(
        appCheckInterface: AppCheckInterface,
    ) {
        self.appCheckInterface = appCheckInterface
    }

    func token() async throws -> AppCheckToken {
        try await appCheckInterface.token(forcingRefresh: false)
    }
}

protocol AppCheckInterface {
    func token(forcingRefresh: Bool) async throws -> AppCheckToken
}

extension AppCheck: AppCheckInterface {
    // No Imp
}
