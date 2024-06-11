import Foundation

import Factory

extension Container {
    var testNetworkClient: Factory<TestNetworkClientInterface> {
        Factory(self) {
            TestNetworkClient()
        }
    }
}
