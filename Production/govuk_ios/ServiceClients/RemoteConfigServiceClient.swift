protocol RemoteConfigServiceClientInterface {
    func fetch() async throws
    func activate() async throws
    func string(forKey key: String) -> String?
    func bool(forKey key: String) -> Bool?
    func int(forKey key: String) -> Int?
    func double(forKey key: String) -> Double?
}

struct RemoteConfigServiceClient: RemoteConfigServiceClientInterface {
    private let remoteConfig: RemoteConfigInterface

    init(remoteConfig: RemoteConfigInterface) {
        self.remoteConfig = remoteConfig
    }

    func fetch() async throws {
        try await remoteConfig.fetchConfig()
    }

    func activate() async throws {
        try await remoteConfig.activateConfig()
    }

    func string(forKey key: String) -> String? {
        return value(key)?.stringValue
    }

    func bool(forKey key: String) -> Bool? {
        return value(key)?.boolValue
    }

    func int(forKey key: String) -> Int? {
        return value(key)?.numberValue.intValue
    }

    func double(forKey key: String) -> Double? {
        return value(key)?.numberValue.doubleValue
    }

    private func value(_ key: String) -> RemoteConfigValueInterface? {
        let value = remoteConfig.configValue(forKey: key)
        return value.isSourceStatic ? nil : value
        // stops Firebase defaulting values when no key present
    }
}
