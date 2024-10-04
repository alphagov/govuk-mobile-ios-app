import Foundation

protocol AppConfigServiceInterface {
    var isAppAvailable: Bool { get }
    var isAppForcedUpdate: Bool { get }
    func isFeatureEnabled(key: Feature) -> Bool
}

public final class AppConfigService: AppConfigServiceInterface {
    var isAppAvailable: Bool = false
    var isAppForcedUpdate: Bool = false
    private var featureFlags: [String: Bool] = [:]

    private let appConfigRepository: AppConfigRepositoryInterface
    private let appConfigServiceClient: AppConfigServiceClientInterface
    private let appVersionProvider: AppVersionProvider

    init(appConfigRepository: AppConfigRepositoryInterface,
         appConfigServiceClient: AppConfigServiceClientInterface,
         appVersionProvider: AppVersionProvider = Bundle.main) {
        self.appConfigRepository = appConfigRepository
        self.appConfigServiceClient = appConfigServiceClient
        self.appVersionProvider = appVersionProvider

        fetchAppConfig()
    }

    private func fetchAppConfig() {
        appConfigRepository.fetchAppConfig(
            filename: ConfigStrings.filename.rawValue,
            completion: { [weak self] result in
                guard let self = self else { return }
                try? self.handleResult(result)
            }
        )

        appConfigServiceClient.fetchAppConfig(
            completion: { [weak self] result in
                guard let self = self else { return }
                try? self.handleResult(result)
            }
        )
    }

    private func handleResult(_ result: Result<AppConfig, AppConfigError>) throws {
        switch result {
        case .success(let appConfig):
            setConfig(appConfig.config)
        case .failure(let error):
            throw error
        }
    }

    private func setConfig(_ config: Config) {
        self.isAppAvailable = config.available
        let appVersionNumber = appVersionProvider.versionNumber ?? ""
        self.isAppForcedUpdate = appVersionNumber.isVersion(lessThan: config.minimumVersion)
        self.featureFlags = self.featureFlags.merging(
            appConfig.config.releaseFlags,
            uniquingKeysWith: { _, new in
                new
            }
        )
    }

    func isFeatureEnabled(key: Feature) -> Bool {
        featureFlags[key.rawValue] ?? false
    }

    private enum ConfigStrings: String {
        case filename = "RemoteConfigResponse"
    }
}
