import FirebaseRemoteConfig

enum RemoteConfigKey: String {
    case topicsWidgetTitle = "topics_widget_title"
}

protocol RemoteConfigServiceClientInterface {
    func fetchAndActivate() async -> Result<Void, Error>
    func string(forKey key: RemoteConfigKey) -> String
    func bool(forKey key: RemoteConfigKey) -> Bool
}

struct RemoteConfigServiceClient: RemoteConfigServiceClientInterface {
    
    private let remoteConfig = RemoteConfig.remoteConfig()
    
    init() {
        let settings = RemoteConfigSettings()
        settings.fetchTimeout = 10
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
    }
    
    func fetchAndActivate() async -> Result<Void, Error> {
        do {
            let _ = try await remoteConfig.fetchAndActivate()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func string(forKey key: RemoteConfigKey) -> String {
        return remoteConfig[key.rawValue].stringValue
    }
    
    func bool(forKey key: RemoteConfigKey) -> Bool {
        return remoteConfig[key.rawValue].boolValue
    }
    
    //func codable<T: Decodable>(forKey key: RemoteConfigKey, type: T.Type) -> T...
    
    
}
