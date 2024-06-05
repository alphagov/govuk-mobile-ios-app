import Foundation

protocol TestServiceInterface {
}

class TestService: TestServiceInterface {
    private var dataStore: TestDataStoreInterface
    private var networkClient: TestNetworkClientInterface

    init(dataStore: TestDataStoreInterface,
         networkClient: TestNetworkClientInterface) {
        self.dataStore = dataStore
        self.networkClient = networkClient
    }
}
