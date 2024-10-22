import Foundation

enum AppConfigError: Error {
    case loadJson
    case remoteJson
    case invalidSignature
}
