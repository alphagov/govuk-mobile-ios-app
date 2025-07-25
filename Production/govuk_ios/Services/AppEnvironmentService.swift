import Foundation

protocol AppEnvironmentServiceInterface {
    var baseURL: URL { get }
    var oneSignalAppId: String { get }
    var authenticationBaseURL: URL { get }
    var authenticationClientId: String { get }
    var authenticationAuthorizeURL: URL { get }
    var authenticationTokenURL: URL { get }
    var chatBaseURL: URL { get }
    var chatAuthToken: String { get }
}

enum AppEnvironmentKey: String {
    case baseURL = "BaseURL"
    case oneSignalAppId = "ONESIGNAL_APP_ID"
    case authenticationClientId = "AUTHENTICATION_CLIENT_ID"
    case authenticationBaseURL = "AUTHENTICATION_BASE_URL"
    case tokenBaseURL = "TOKEN_BASE_URL"
    case chatBaseURL = "CHAT_BASE_URL"
    case chatAuthToken = "CHAT_AUTH_TOKEN"
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

    var authenticationAuthorizeURL: URL {
        authenticationBaseURL.appendingPathComponent("oauth2/authorize")
    }

    var authenticationTokenURL: URL {
        tokenBaseURL.appendingPathComponent("oauth2/token")
    }

    var revokeTokenURL: URL {
        authenticationBaseURL.appendingPathComponent("oauth2/revoke")
    }

    private func string(for key: AppEnvironmentKey) -> String {
        guard let value = config[key.rawValue] as? String else {
            preconditionFailure("No AppEnvironment value found for " + key.rawValue)
        }
        return value
    }

    var authenticationBaseURL: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = string(for: .authenticationBaseURL)
        return components.url!
    }

    var tokenBaseURL: URL {
        let urlString = string(for: .tokenBaseURL)
        return URL(string: urlString)!
    }

    var chatBaseURL: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = string(for: .chatBaseURL)
        components.path = "/api/v0"
        return components.url!
    }

    var chatAuthToken: String {
        string(for: .chatAuthToken)
    }
}
