import FirebaseRemoteConfig

protocol RemoteConfigInterface {
    func fetchConfig() async throws
    func activateConfig() async throws
    func configValue(forKey key: String) -> RemoteConfigValueInterface
}

protocol RemoteConfigValueInterface {
    var stringValue: String { get }
    var boolValue: Bool { get }
    var numberValue: NSNumber { get }
    var isSourceStatic: Bool { get }
}

extension RemoteConfig: RemoteConfigInterface {
    func fetchConfig() async throws {
        _ = try await fetch()
    }
    func activateConfig() async throws {
        _ = try await activate()
    }
    func configValue(forKey key: String) -> RemoteConfigValueInterface {
        self[key]
    }
}

extension RemoteConfigValue: RemoteConfigValueInterface {
    var isSourceStatic: Bool { return source == .static }
}
