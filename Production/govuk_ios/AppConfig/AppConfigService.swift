import Foundation

public final class AppConfigService {
    private var featureFlags: [String: Bool] = [:]
    private let configProvider: AppConfigProviderInterface

    private enum ConfigStrings: String {
        case filename = "RemoteConfigResponse"
        case fileType = "json"
    }

    init(configProvider: AppConfigProviderInterface) {
        self.configProvider = configProvider
        fetchAppConfig()
    }

    private func fetchAppConfig() {
        configProvider.fetchAppConfig(
            filename: ConfigStrings.filename.rawValue) { [weak self] result in
            guard let self = self else { return }
            try? self.getFeatureflags(result: result)
        }
    }

    private func getFeatureflags(result: Result<AppConfig, AppConfigServiceError>) throws {
        switch result {
        case .success(let appConfig):
            self.featureFlags = appConfig.config.releaseFlags
        case .failure(let error):
            throw error
        }
    }

    func isFeatureEnabled(key: Feature) -> Bool {
        if let feature = featureFlags[key.rawValue] {
            return feature
        }
        return false
    }
}
