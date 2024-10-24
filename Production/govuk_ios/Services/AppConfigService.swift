import Foundation

protocol AppConfigServiceInterface {
    var isAppAvailable: Bool { get }
    var isAppForcedUpdate: Bool { get }
    var isAppRecommendUpdate: Bool { get }
    var searchApiUrl: String { get }
    func fetchAppConfig(completion: @escaping () -> Void)
    func isFeatureEnabled(key: Feature) -> Bool
}

public final class AppConfigService: AppConfigServiceInterface {
    var isAppAvailable: Bool = false
    var isAppForcedUpdate: Bool = false
    var isAppRecommendUpdate: Bool = false
    var searchApiUrl: String = ""
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
    }

    func fetchAppConfig(completion: @escaping () -> Void) {
        appConfigRepository.fetchAppConfig(
            filename: ConfigStrings.filename.rawValue,
            completion: { [weak self] result in
                self?.handleResult(result)
                completion()
            }
        )
//
//        appConfigServiceClient.fetchAppConfig(
//            completion: { [weak self] result in
//                self?.handleResult(result)
//                completion()
//            }
//        )
    }

    private func handleResult(_ result: Result<AppConfig, AppConfigError>) {
        switch result {
        case .success(let appConfig):
            setConfig(appConfig.config)
        case .failure(.invalidSignature):
            self.isAppForcedUpdate = true
        case .failure:
            self.isAppAvailable = false
        }
    }

    private func setConfig(_ config: Config) {
        self.searchApiUrl = config.searchApiUrl ?? Constants.API.defaultSearchApiUrlString
        self.isAppAvailable = config.available
        let appVersionNumber = appVersionProvider.versionNumber ?? ""
        self.isAppForcedUpdate = appVersionNumber.isVersion(lessThan: config.minimumVersion)
        self.isAppRecommendUpdate = appVersionNumber.isVersion(lessThan: config.recommendedVersion)
        self.featureFlags = self.featureFlags.merging(
            config.releaseFlags,
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
