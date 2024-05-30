import Foundation

protocol TestServiceInterface {
}

class TestService: TestServiceInterface {
    @Inject private var dataStore: TestDataStoreInterface
    @Inject private var networkClient: TestNetworkClientInterface
}
