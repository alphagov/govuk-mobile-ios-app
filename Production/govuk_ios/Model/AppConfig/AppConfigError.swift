import Foundation

enum AppConfigError: Error {
    case loadJsonError
    case remoteJsonError
    case invalidSignatureError
}
