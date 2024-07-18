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
