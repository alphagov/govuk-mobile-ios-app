import Foundation

protocol AppEnvironmentServiceInterface {
    var baseURL: URL { get }
    var oneSignalAppId: String { get }
    var authenticationClientId: String { get }
}

enum AppEnvironmentKey: String {
    case baseURL = "BaseURL"
    case oneSignalAppId = "ONESIGNAL_APP_ID"
    case authenticationClientId = "AUTHENTICATION_CLIENT_ID"
}

struct AppEnvironmentService: AppEnvironmentServiceInterface {
    private let config: [String: Any]

    init(config: [String: Any]) {
        self.config = config
    }

    var baseURL: URL {
        let urlString = string(for: .baseURL)
        return URL(string: urlString)!
    }

    var oneSignalAppId: String {
        string(for: .oneSignalAppId)
    }

    var authenticationClientId: String {
        string(for: .authenticationClientId)
    }

    private func string(for key: AppEnvironmentKey) -> String {
        guard let value = config[key.rawValue] as? String else {
            preconditionFailure("No AppEnvironment value found for " + key.rawValue)
        }
        return value
    }
}
