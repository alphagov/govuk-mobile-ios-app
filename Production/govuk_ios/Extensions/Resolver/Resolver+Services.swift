import Foundation

import Resolver

extension Resolver {
    static func registerServices() {
        register(
            TestServiceInterface.self,
            factory: {
                TestService()
            }
        )
    }
}
