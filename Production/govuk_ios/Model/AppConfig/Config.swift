import Foundation

struct Config: Decodable {
    let available: Bool
    let minimumVersion: String
    let recommendedVersion: String
    let releaseFlags: [String: Bool]
    let lastUpdated: String
    let searchApiUrl: String?
    var authenticationIssuerBaseUrl: String?
}
