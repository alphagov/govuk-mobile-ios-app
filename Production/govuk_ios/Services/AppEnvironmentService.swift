import Foundation

protocol AppEnvironmentServiceInterface {
    var baseURL: URL { get }
}

enum AppEnvironment: String {
    case baseURL = "Base URL"
}

struct AppEnvironmentService: AppEnvironmentServiceInterface {
    private let config: [String: Any]

    var baseURL: URL {
        let urlString = string(for: .baseURL)
        return URL(string: urlString)!
    }

    init(config: [String: Any]) {
        self.config = config
    }

    private func string(for key: AppEnvironment) -> String {
        guard let value = config[key.rawValue] as? String else {
            preconditionFailure("No AppEnvironment value found for " + key.rawValue)
        }
        return value
    }
}
