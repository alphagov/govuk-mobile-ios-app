import Foundation
import Factory

protocol AppConfigServiceInterface {
    func fetchAppConfig(completion: @escaping FetchAppConfigCompletion)
    func isFeatureEnabled(key: Feature) -> Bool
}

public final class AppConfigService: AppConfigServiceInterface {
    private var featureFlags: [String: Bool] = [:]

    private let appConfigServiceClient: AppConfigServiceClientInterface
    private let appVersionProvider: AppVersionProvider

    init(appConfigServiceClient: AppConfigServiceClientInterface,
         appVersionProvider: AppVersionProvider = Bundle.main) {
        self.appConfigServiceClient = appConfigServiceClient
        self.appVersionProvider = appVersionProvider
    }

    func fetchAppConfig(completion: @escaping FetchAppConfigCompletion) {
        appConfigServiceClient.fetchAppConfig(
            completion: { [weak self] result in
                self?.handleResult(result)
                completion(result)
            }
        )
    }

    private func handleResult(_ result: FetchAppConfigResult) {
        switch result {
        case .success(let appConfig):
            setConfig(appConfig.config)
        default:
            break
        }
    }

    private func setConfig(_ config: Config) {
        self.featureFlags = self.featureFlags.merging(
            config.releaseFlags,
            uniquingKeysWith: { _, new in
                new
            }
        )
        updateSearch(urlString: config.searchApiUrl)
    }

    private func updateSearch(urlString: String?) {
        guard let urlString = urlString,
              let url = URL(string: urlString),
              let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        else { return }
        Constants.API.defaultSearchPath = components.path
        Container.shared.reregisterSearchAPIClient(url: url)
    }

    func isFeatureEnabled(key: Feature) -> Bool {
        featureFlags[key.rawValue] ?? false
    }
}
