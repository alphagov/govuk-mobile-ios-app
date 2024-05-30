import Foundation

protocol TestServiceInterface {
}

class TestService: TestServiceInterface {
    @Inject private var dataStore: TestDataStore
    @Inject private var networkClient: TestNetworkClient
}
