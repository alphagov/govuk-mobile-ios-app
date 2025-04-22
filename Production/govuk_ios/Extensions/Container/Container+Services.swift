import Foundation
import Factory
import Onboarding
import GOVKit

import SecureStore
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

    var searchService: Factory<SearchServiceInterface> {
        Factory(self) {
            SearchService(
                serviceClient: self.searchServiceClient(),
                repository: self.searchHistoryRepository()
            )
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
                userDefaults: UserDefaults.standard
            )
        }
        .scope(.singleton)
    }

    var appLaunchService: Factory<AppLaunchServiceInterface> {
        Factory(self) {
            AppLaunchService(
                configService: self.appConfigService.resolve(),
                topicService: self.topicsService.resolve()
            )
        }.scope(.singleton)
    }

    var appConfigService: Factory<AppConfigServiceInterface> {
        Factory(self) {
            AppConfigService(
                appConfigServiceClient: self.appConfigServiceClient.resolve()
            )
        }.scope(.singleton)
    }

    var onboardingService: Factory<OnboardingServiceInterface> {
        Factory(self) {
            OnboardingService(
                userDefaults: UserDefaults.standard
            )
        }
    }

    var topicsService: Factory<TopicsServiceInterface> {
        Factory(self) {
            TopicsService(
                topicsServiceClient: self.topicsServiceClient(),
                topicsRepository: self.topicsRepository(),
                analyticsService: self.analyticsService(),
                userDefaults: UserDefaults.standard
            )
        }
    }

    var appEnvironmentService: Factory<AppEnvironmentServiceInterface> {
        Factory(self) {
            guard let config = Bundle.main.infoDictionary else {
                fatalError("Info.plist not found")
            }
            return AppEnvironmentService(
                config: config
            )
        }.scope(.singleton)
    }

    var notificationService: Factory<NotificationServiceInterface> {
        Factory(self) {
            NotificationService(
                environmentService: self.appEnvironmentService.resolve(),
                notificationCenter: UNUserNotificationCenter.current()
            )
        }
    }

    var authenticationOnboardingService: Factory<AuthenticationOnboardingServiceInterface> {
        Factory(self) {
            AuthenticationOnboardingService(
                userDefaults: UserDefaults.standard
            )
        }
    }

    @MainActor
    var authenticationService: Factory<AuthenticationServiceInterface> {
        Factory(self) {
            AuthenticationService(
                authenticationServiceClient: self.authenticationServiceClient.resolve(),
                authenticationTokenSet: AuthenticationTokenSet.shared
            )
        }
    }

    var secureStoreService: Factory<SecureStorable> {
        Factory(self) {
            SecureStoreService(
                configuration: self.secureStoreConfiguration.resolve()
            )
        }
    }

    var localAuthenticationService: Factory<LocalAuthenticationServiceInterface> {
        Factory(self) {
            LocalAuthenticationService(
                userDefaults: UserDefaults.standard
            )
        }
    }

    var authenticationTokenService: Factory<AuthenticationTokenServiceInterface> {
        Factory(self) {
            AuthenticationTokenService(
                secureStoreService: self.secureStoreService.resolve()
            )
        }
    }
}
