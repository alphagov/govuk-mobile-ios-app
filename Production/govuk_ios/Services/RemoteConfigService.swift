//

protocol RemoteConfigServiceInterface {
    func fetchAndActivate() async -> Result<Void,Error>
    
    var topicsWidgetTitle: String { get }
}

class RemoteConfigService: RemoteConfigServiceInterface {
    
    private let remoteConfigServiceClient: RemoteConfigServiceClientInterface
    
    init(remoteConfigServiceClient: RemoteConfigServiceClientInterface) {
        self.remoteConfigServiceClient = remoteConfigServiceClient
    }
    
    var topicsWidgetTitle: String {
        remoteConfigServiceClient.string(forKey: .topicsWidgetTitle)
    }
    
    func fetchAndActivate() async -> Result<Void,Error> {
        await remoteConfigServiceClient.fetchAndActivate()
    }
}
