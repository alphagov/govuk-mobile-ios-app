import Foundation

import Resolver

typealias Inject = Injected
typealias LazyInject = LazyInjected

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        registerDataStores()
        registerNetworkClients()
        registerServices()
    }
}
