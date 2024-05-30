import Foundation

import Resolver

extension Resolver {
    static func registerNetworkClients() {
        register(
            TestNetworkClientInterface.self,
            factory: {
                TestNetworkClient()
            }
        )
    }
}
