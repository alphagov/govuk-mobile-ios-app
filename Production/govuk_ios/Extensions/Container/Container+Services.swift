import Foundation

import Factory

extension Container {
    var testService: Factory<TestServiceInterface> {
        Factory(self) {
            TestService(
                dataStore: self.testDataStore(),
                networkClient: self.testNetworkClient()
            )
        }
    }

    var deeplinkService: Factory<DeeplinkServiceInterface> {
        Factory(self) {
            DeeplinkService()
        }
    }
}
