import Foundation

struct Config: Decodable {
    let available: Bool
    let minimumVersion: String
    let recommendedVersion: String
    let releaseFlags: [String: Bool]
    let lastUpdated: String
    let searchApiUrl: String?
    var authenticationIssuerBaseUrl: String?
    let chatPollIntervalSeconds: Int?
    let alertBanner: AlertBanner?
    let userFeedbackBanner: UserFeedbackBanner?
}

struct AlertBanner: Decodable {
    let id: String
    let body: String
    let link: Link?
}

extension AlertBanner {
    struct Link: Decodable {
        let title: String
        let url: URL
    }
}

struct UserFeedbackBanner: Decodable {
    let body: String
    let link: Link
}

extension UserFeedbackBanner {
    struct Link: Decodable {
        let title: String
        let url: URL
    }
}
