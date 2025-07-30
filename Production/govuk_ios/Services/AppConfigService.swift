import Foundation
import Factory
import GOVKit

protocol AppConfigServiceInterface {
    func fetchAppConfig(completion: @escaping FetchAppConfigCompletion)
    func isFeatureEnabled(key: Feature) -> Bool
    var chatPollIntervalSeconds: TimeInterval { get }
}

public final class AppConfigService: AppConfigServiceInterface {
    private var featureFlags: [String: Bool] = [:]

    private let appConfigServiceClient: AppConfigServiceClientInterface
    private var retryInterval: Int?

    var chatPollIntervalSeconds: TimeInterval = 3.0

    init(appConfigServiceClient: AppConfigServiceClientInterface) {
        self.appConfigServiceClient = appConfigServiceClient
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
        guard case .success(let appConfig) = result
        else { return }
        setConfig(appConfig.config)
    }

    private func setConfig(_ config: Config) {
        self.featureFlags = self.featureFlags.merging(
            config.releaseFlags,
            uniquingKeysWith: { _, new in
                new
            }
        )
        updateSearch(urlString: config.searchApiUrl)
        updateChatPollInterval(config.chatPollIntervalSeconds)
    }

    private func updateChatPollInterval(_ interval: Int?) {
        guard let pollInterval = interval,
              pollInterval > 0 else {
            return
        }
        chatPollIntervalSeconds = TimeInterval((pollInterval))
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
