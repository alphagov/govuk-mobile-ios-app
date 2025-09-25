import Foundation
import Factory
import GOVKit

protocol AppConfigServiceInterface {
    func fetchAppConfig(completion: @escaping FetchAppConfigCompletion)
    func isFeatureEnabled(key: Feature) -> Bool
    var chatPollIntervalSeconds: TimeInterval { get }
    var alertBanner: AlertBanner? { get }
    var chatBanner: ChatBanner? { get }
    var userFeedbackBanner: UserFeedbackBanner? { get }
    var chatUrls: ChatURLs? { get }
    var refreshTokenExpirySeconds: Int? { get }
}

public final class AppConfigService: AppConfigServiceInterface {
    private var featureFlags: [String: Bool] = [:]

    private let appConfigServiceClient: AppConfigServiceClientInterface
    private let analyticsService: AnalyticsServiceInterface
    private var retryInterval: Int?

    var chatPollIntervalSeconds: TimeInterval = 3.0
    var alertBanner: AlertBanner?
    var chatBanner: ChatBanner?
    var userFeedbackBanner: UserFeedbackBanner?
    private(set) var chatUrls: ChatURLs?
    private(set) var refreshTokenExpirySeconds: Int?

    init(appConfigServiceClient: AppConfigServiceClientInterface,
         analyticsService: AnalyticsServiceInterface) {
        self.appConfigServiceClient = appConfigServiceClient
        self.analyticsService = analyticsService
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
        case .failure(let error):
            analyticsService.track(error: error)
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
        updateChatPollInterval(config.chatPollIntervalSeconds)
        alertBanner = config.alertBanner
        chatBanner = config.chatBanner
        userFeedbackBanner = config.userFeedbackBanner
        chatUrls = config.chatUrls
    }

    private func updateChatPollInterval(_ interval: Int?) {
        guard let pollInterval = interval,
              pollInterval > 0 else {
            return
        }
        chatPollIntervalSeconds = TimeInterval(pollInterval)
    }

    private func updateTokenExpirySeconds(_ expiry: Int?) {
        guard let localExpiry = expiry,
              localExpiry > 0 else {
            return
        }
        refreshTokenExpirySeconds = localExpiry
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
