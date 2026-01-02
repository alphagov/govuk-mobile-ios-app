import Foundation
import FirebaseRemoteConfig

protocol RemoteConfigValueInterface {
    var stringValue: String { get }
    var boolValue: Bool { get }
    var numberValue: NSNumber { get }
    var isSourceStatic: Bool { get }
}

extension RemoteConfigValue: RemoteConfigValueInterface {
    var isSourceStatic: Bool { return source == .static }
}
