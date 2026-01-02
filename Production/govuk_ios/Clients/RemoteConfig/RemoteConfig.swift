import Foundation
import FirebaseRemoteConfig

protocol RemoteConfigInterface {
    func fetchConfig() async throws
    func activateConfig() async throws
    func configValue(forKey key: String) -> RemoteConfigValueInterface
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
