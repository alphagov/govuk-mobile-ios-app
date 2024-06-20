import Foundation
import GAnalytics
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

    var analyticsService: Factory<GovukAnalyticsServiceInterface> {
        Factory(self) {
            GovukAnalyticsService(analytics: GAnalytics())
        }
        .scope(.singleton)
    }
}
