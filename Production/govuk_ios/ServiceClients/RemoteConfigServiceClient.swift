import FirebaseRemoteConfig

protocol RemoteConfigServiceClientInterface {
    func fetch() async throws
    func activate() async throws
    func string(forKey key: String) -> String?
    func bool(forKey key: String) -> Bool?
    func int(forKey key: String) -> Int?
    func double(forKey key: String) -> Double?
}

struct RemoteConfigServiceClient: RemoteConfigServiceClientInterface {
    private let remoteConfig = RemoteConfig.remoteConfig()
    init() {
        let settings = RemoteConfigSettings()
        settings.fetchTimeout = 5
        remoteConfig.configSettings = settings
    }
    func fetch() async throws {
        try await remoteConfig.fetch()
    }
    func activate() async throws {
        try await remoteConfig.activate()
    }
    func string(forKey key: String) -> String? {
        if let value = value(key) {
            return value.stringValue
        }
        return nil
    }
    func bool(forKey key: String) -> Bool? {
        if let value = value(key) {
            return value.boolValue
        }
        return nil
    }
    func int(forKey key: String) -> Int? {
        if let value = value(key) {
            return value.numberValue.intValue
        }
        return nil
    }
    func double(forKey key: String) -> Double? {
        if let value = value(key) {
            return value.numberValue.doubleValue
        }
        return nil
    }
    private func value(_ key: String) -> RemoteConfigValue? {
        let value = remoteConfig[key]
        return value.source == .static ? nil : value
        // stops Firebase defaulting values when no key present
    }
}
