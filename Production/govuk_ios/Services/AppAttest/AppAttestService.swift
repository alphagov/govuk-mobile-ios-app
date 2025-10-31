import Foundation
import Firebase
import FirebaseCore
import FirebaseAppCheck
import GOVKit

protocol AppAttestServiceInterface {
    func token() async throws -> AppCheckToken
}

class AppAttestService: NSObject,
                        AppAttestServiceInterface {
    private let appCheckInterface: AppCheckInterface
    private let analyticsService: AnalyticsServiceInterface

    init(
        appCheckInterface: AppCheckInterface,
        analyticsService: AnalyticsServiceInterface,
    ) {
        self.appCheckInterface = appCheckInterface
        self.analyticsService = analyticsService
    }

    func token() async throws -> AppCheckToken {
        do {
            return try await appCheckInterface.token(forcingRefresh: false)
        } catch {
            analyticsService.track(error: error)
            throw AppAttestError.tokenGeneration
        }
    }
}

protocol AppCheckInterface {
    func token(forcingRefresh: Bool) async throws -> AppCheckToken
}

extension AppCheck: AppCheckInterface {
    // No Imp
}

enum AppAttestError: Error {
    case tokenGeneration
}

extension AppAttestError {
    var govukErrorCode: String {
        switch self {
        case .tokenGeneration:
            return "4.0.1"
        }
    }
}
