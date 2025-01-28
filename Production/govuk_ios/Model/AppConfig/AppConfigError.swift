import Foundation

enum AppConfigError: Error {
    case remoteJson
    case invalidSignature
    case networkUnavailable
}
