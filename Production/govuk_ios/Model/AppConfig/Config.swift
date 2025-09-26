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
    let refreshTokenExpirySeconds: Int?
    let alertBanner: AlertBanner?
    let chatBanner: ChatBanner?
    let userFeedbackBanner: UserFeedbackBanner?
    let chatUrls: ChatURLs?
}

struct ChatURLs: Decodable {
    let termsAndConditions: URL?
    let privacyNotice: URL?
    let about: URL?
    let feedback: URL?
}
