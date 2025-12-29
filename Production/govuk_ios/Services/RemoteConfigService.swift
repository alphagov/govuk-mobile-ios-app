import GOVKit

enum RemoteConfigKey: String {
    
    case testKey = "test_key"
}

protocol RemoteConfigServiceInterface {
    func fetch() async
    func activate() async
    
    func string(forKey key: RemoteConfigKey, defaultValue: String) -> String
    func bool(forKey key: RemoteConfigKey, defaultValue: Bool) -> Bool
    func int(forKey key: RemoteConfigKey, defaultValue: Int) -> Int
    func double(forKey key: RemoteConfigKey, defaultValue: Double) -> Double
    
}

class RemoteConfigService: RemoteConfigServiceInterface {
    
    private let remoteConfigServiceClient: RemoteConfigServiceClientInterface
    private let analyticsService: AnalyticsServiceInterface
    
    init(remoteConfigServiceClient: RemoteConfigServiceClientInterface, analyticsService: AnalyticsServiceInterface) {
        self.remoteConfigServiceClient = remoteConfigServiceClient
        self.analyticsService = analyticsService
    }
    
    func fetch() async {
        do {
            try await remoteConfigServiceClient.fetch()
        } catch {
            analyticsService.track(error: error)
        }
    }
    
    func activate() async {
        do {
            try await remoteConfigServiceClient.activate()
        } catch {
            analyticsService.track(error: error)
        }
    }
    
    func string(forKey key: RemoteConfigKey, defaultValue: String) -> String {
        remoteConfigServiceClient.string(forKey: key.rawValue) ?? defaultValue
    }
    
    func bool(forKey key: RemoteConfigKey, defaultValue: Bool) -> Bool {
        remoteConfigServiceClient.bool(forKey: key.rawValue) ?? defaultValue
    }
    
    func int(forKey key: RemoteConfigKey, defaultValue: Int) -> Int {
        remoteConfigServiceClient.int(forKey: key.rawValue) ?? defaultValue
    }
    
    func double(forKey key: RemoteConfigKey, defaultValue: Double) -> Double {
        remoteConfigServiceClient.double(forKey: key.rawValue) ?? defaultValue
    }
    
}
