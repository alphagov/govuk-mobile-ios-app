import Foundation

protocol AppConfigServiceInterface {
    func isFeatureEnabled(key: Feature) -> Bool
}

public final class AppConfigService: AppConfigServiceInterface {
    private var featureFlags: [String: Bool] = [:]
    private let configProvider: AppConfigProviderInterface

    private enum ConfigStrings: String {
        case filename = "RemoteConfigResponse"
    }

    init(configProvider: AppConfigProviderInterface) {
        self.configProvider = configProvider
        fetchLocalAppConfig()
    }

    private func fetchLocalAppConfig() {
        configProvider.fetchLocalAppConfig(
            filename: ConfigStrings.filename.rawValue,
            completion: { [weak self] result in
                guard let self = self else { return }
                try? self.setFeatureflags(result: result)
            }
        )
    }

    private func fetchRemoteAppConfig() {
        configProvider.fetchRemoteAppConfig(completion: { [weak self] result in
            guard let self = self else { return }
            try? self.setFeatureflags(result: result)
        })
    }

    private func setFeatureflags(result: Result<AppConfig, AppConfigError>) throws {
        switch result {
        case .success(let appConfig):
            self.featureFlags = appConfig.config.releaseFlags
        case .failure(let error):
            throw error
        }
    }

    func isFeatureEnabled(key: Feature) -> Bool {
        featureFlags[key.rawValue] ?? false
    }
}
