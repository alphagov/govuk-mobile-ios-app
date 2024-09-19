import Foundation
import Factory
import Onboarding

import Firebase
import FirebaseCrashlytics

extension Container {
    var activityService: Factory<ActivityServiceInterface> {
        Factory(self) {
            ActivityService(
                repository: self.activityRepository()
            )
        }
    }

    var analyticsService: Factory<AnalyticsServiceInterface> {
        Factory(self) {
            self.baseAnalyticsService()
        }
    }

    var onboardingAnalyticsService: Factory<OnboardingAnalyticsService> {
        Factory(self) {
            self.baseAnalyticsService()
        }
    }

    var baseAnalyticsService: Factory<AnalyticsServiceInterface & OnboardingAnalyticsService> {
        Factory(self) {
            AnalyticsService(
                clients: [
                    FirebaseClient(
                        firebaseApp: FirebaseApp.self,
                        firebaseAnalytics: Analytics.self
                    ),
                    CrashlyticsClient(crashlytics: Crashlytics.crashlytics())
                ],
                userDefaults: .standard
            )
        }
        .scope(.singleton)
    }

    var appConfigService: Factory<AppConfigServiceInterface> {
        Factory(self) {
            AppConfigService(
                configProvider:
                    AppConfigProvider(
                        apiService: APIServiceClient(
                            baseUrl: URL(string: Constants.API.appConfigUrl)!,
                            session: URLSession(configuration: .default),
                            requestBuilder: RequestBuilder()
                        )
                    )
            )
        }.scope(.singleton)
    }

    var onboardingService: Factory<OnboardingServiceInterface> {
        Factory(self) {
            OnboardingService(
                userDefaults: .standard
            )
        }
    }
}
