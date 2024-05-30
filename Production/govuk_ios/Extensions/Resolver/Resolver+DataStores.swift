import Foundation

import Resolver

extension Resolver {
    static func registerDataStores() {
        register(
            TestDataStoreInterface.self,
            factory: {
                TestDataStore()
            }
        )
    }
}
