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
    let chatUrls: ChatURLs?
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

struct ChatURLs: Decodable {
    let termsAndConditions: URL?
    let privacyNotice: URL?
    let about: URL?
    let feedback: URL?
}
