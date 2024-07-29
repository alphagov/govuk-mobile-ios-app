import Foundation
import GAnalytics
import Logging
import Factory

extension Container {
    var analyticsService: Factory<AnalyticsServiceInterface> {
        Factory(self) {
            AnalyticsService(
                analytics: GAnalytics(),
                preferenceStore: self.analyticsPreferenceStore()
            )
        }
        .scope(.singleton)
    }

    var onboardingService: Factory<OnboardingServiceInterface> {
        Factory(self) {
            OnboardingService(
                userDefaults: .standard
            )
        }
    }
}
