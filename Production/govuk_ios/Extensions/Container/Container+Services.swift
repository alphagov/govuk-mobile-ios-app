import Foundation
import UIKit

import Factory

extension Container {
    var coordinatorBuilder: Factory<CoordinatorBuilder> {
        Factory(self) {
            CoordinatorBuilder(
                container: .shared
            )
        }
        .scope(.singleton)
    }

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
