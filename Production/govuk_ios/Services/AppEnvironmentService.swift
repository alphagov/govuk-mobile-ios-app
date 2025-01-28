import Foundation

protocol AppEnvironmentServiceInterface {
    var baseURL: URL { get }
    var oneSignalAppId: String { get }
}

enum AppEnvironmentKey: String {
    case baseURL = "BaseURL"
    case oneSignalAppId = "ONESIGNAL_APP_ID"
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

    private func string(for key: AppEnvironmentKey) -> String {
        guard let value = config[key.rawValue] as? String else {
            preconditionFailure("No AppEnvironment value found for " + key.rawValue)
        }
        return value
    }
}
