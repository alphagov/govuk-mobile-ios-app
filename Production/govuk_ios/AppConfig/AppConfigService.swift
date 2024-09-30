import Foundation

protocol AppConfigServiceInterface {
    var isAppAvailable: Bool { get }
    func isFeatureEnabled(key: Feature) -> Bool
}

public final class AppConfigService: AppConfigServiceInterface {
    private let appConfigRepository: AppConfigRepositoryInterface
    private let appConfigServiceClient: AppConfigServiceClientInterface

    var isAppAvailable: Bool = false
    private var featureFlags: [String: Bool] = [:]

    private enum ConfigStrings: String {
        case filename = "RemoteConfigResponse"
    }

    init(appConfigRepository: AppConfigRepositoryInterface,
         appConfigServiceClient: AppConfigServiceClientInterface) {
        self.appConfigRepository = appConfigRepository
        self.appConfigServiceClient = appConfigServiceClient

        fetchAppConfig()
    }

    private func fetchAppConfig() {
        appConfigRepository.fetchAppConfig(
            filename: ConfigStrings.filename.rawValue,
            completion: { [weak self] result in
                guard let self = self else { return }
                try? self.setConfig(result: result)
            }
        )

        appConfigServiceClient.fetchAppConfig(
            completion: { [weak self] result in
                guard let self = self else { return }
                try? self.setConfig(result: result)
            }
        )
    }

    private func setConfig(result: Result<AppConfig, AppConfigError>) throws {
        switch result {
        case .success(let appConfig):
            self.isAppAvailable = appConfig.config.available
            self.featureFlags = appConfig.config.releaseFlags
        case .failure(let error):
            throw error
        }
    }

    func isFeatureEnabled(key: Feature) -> Bool {
        featureFlags[key.rawValue] ?? false
    }
}
