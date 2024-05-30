import Foundation

import Resolver

extension Resolver {
    static func registerNetworkClients() {
        register(
            TestNetworkClient.self,
            factory: {
                TestNetworkClient()
            }
        )
    }
}
