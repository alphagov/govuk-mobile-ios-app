import Foundation
import GAnalytics
import Logging
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

    var analyticsService: Factory<AnalyticsServiceInterface> {
        Factory(self) {
            AnalyticsService(
                analytics: GAnalytics(),
                preferenceStore: self.analyticsPreferenceStore()
            )
        }
        .scope(.singleton)
    }
}
